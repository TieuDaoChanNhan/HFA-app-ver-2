import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/services/services.dart';
import 'package:health_for_all/pages/notification/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class FirebaseMessagingApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final notiController = Get.find<NotificationController>();
  static Future<void> init() async {
    await messaging.setAutoInitEnabled(true);
    // Request permission for iOS
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      announcement: false,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the token and update Firestore
    String? token = await messaging.getToken();
    if (token != null) {
      await _storeFcmTokenLocally(token);
    }

    // Listen for token refresh
    messaging.onTokenRefresh.listen((newToken) async {
      await _storeFcmTokenLocally(newToken);
    });

    // // Handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    //   if (message != null) {
    //     print('Title: ${message.notification!.title}');
    //     print('Body: ${message.notification!.body}');
    //     print('Payload: ${message.data}');
    //     String tripId = message.data['tripId'];
    //     print('Trip ID: $tripId');
    //     _showNotification(message);
    //   }
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('foreground message');
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        LocalNotifications.showNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          payload: message.data.toString(),
        );
      }
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      if (message != null) {
        print('Title: ${message.notification!.title}');
        print('Body: ${message.notification!.body}');
        print('Payload: ${message.data}');
        String tripId = message.data['tripId'];
        print('Trip ID: $tripId');
      }
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Replace with your channel id
      'your_channel_name', // Replace with your channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
    );
  }

  static Future<void> _storeFcmTokenLocally(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmtoken', token);
    print('FCM Token stored locally: $token');
  }

  static Future<void> updateFcmTokenInFirestore(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('fcmtoken');
    if (token != null) {
      String id = await FirebaseApi.getDocumentId('users', 'id', userId) ?? "";
      await _firestore.collection('users').doc(id).update({
        'fcmtoken': token,
      });
      print('FCM Token updated for user: $userId');
    }
  }

  static Future sendMessage(String fcmtoken, String title, String body,
      String type, String page, String uid, String status,
      {String? diagnosticId, String? medicalId}) async {
    final String serverkey = await getAccessToken();
    const String endpointCloudMessaging =
        'https://fcm.googleapis.com/v1/projects/hfa---health-for-all/messages:send';
    final Map<String, dynamic> data = {
      'message': {
        "token": fcmtoken,
        'notification': {"title": title, "body": body},
        'data': {"page": page, 'type': type, 'status': status}
      }
    };
    try {
      await http
          .post(Uri.parse(endpointCloudMessaging),
              body: jsonEncode(data),
              headers: <String, String>{
                "Content-Type": 'application/json',
                "Authorization": 'Bearer $serverkey'
              })
          .then((response) => log('thanh cong gui tin nhan$response'))
          .catchError((e) => log(e.toString()));
      notiController.addNoti(title, body, page, type, uid, status,
          diagnosticId: diagnosticId, medicalId: medicalId);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  static Future<String> getAccessToken() async {
    // final Map<String, dynamic> serviceAccount = {
    //   "type": dotenv.env['SERVICE_TYPE'],
    //   "project_id": dotenv.env['FIREBASE_PROJECT_ID'],
    //   "private_key_id": dotenv.env['SERVICE_PRIVATE_KEY_ID'],
    //   "private_key": dotenv.env['SERVICE_PRIVATE_KEY'],
    //   "client_email": dotenv.env['SERVICE_CLIENT_EMAIL'],
    //   "client_id": dotenv.env['SERVICE_CLIENT_ID'],
    //   "auth_uri": dotenv.env['SERVICE_AUTH_URI'],
    //   "token_uri": dotenv.env['TOKEN_URI'],
    //   "auth_provider_x509_cert_url":
    //       dotenv.env['SERVICE_AUTH_PROVIDER_X509_CERT_URL'],
    //   "client_x509_cert_url": dotenv.env['SERVICE_CLIENT_X509_CERT_URL'],
    //   "universe_domain": dotenv.env['SERVICE_UNIVERSE_DOMAIN']
    // };

    final serviceAccount = dotenv.env['SERVICE_ACCOUNT_JSON']!;

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email'
    ];

    final auth.ServiceAccountCredentials credentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccount);

    final http.Client client = http.Client();
    final auth.AccessCredentials accessCredentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      credentials,
      scopes,
      client,
    );

    client.close();
    return accessCredentials.accessToken.data;
  }
}
