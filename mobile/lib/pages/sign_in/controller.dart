import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/routes/names.dart';
import 'package:health_for_all/common/services/storage.dart';
import 'package:health_for_all/common/store/user.dart';

import 'state.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'https://www.googleapis.com/auth/cloud-platform',
]);

class SignInController extends GetxController {
  final state = SignInState();
  final db = FirebaseFirestore.instance;

  Future<void> handleSignIn() async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final user = await _googleSignIn.signIn();
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      if (user != null) {
        final gAuthentication = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: gAuthentication.idToken,
          accessToken: gAuthentication.accessToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.snackbar(
          "Thành công",
          "Đăng nhập thành công",
          snackPosition: SnackPosition.BOTTOM,
        );
        final displayName = user.displayName ?? user.email;
        final email = user.email;
        final id = user.id;
        final photoUrl = user.photoUrl ?? "";

        final userProfile = UserLoginResponseEntity()
          ..email = email
          ..accessToken = id
          ..displayName = displayName
          ..photoUrl = photoUrl;
        UserStore.to.saveProfile(userProfile);
        await StorageService.to
            .saveUserCredentials(email, id, displayName, photoUrl);

        final userbase = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userdata, options) =>
                  userdata.toFirestore(),
            )
            .where("id", isEqualTo: id)
            .get();

        if (userbase.docs.isEmpty) {
          final data = UserData(
            id: id,
            name: displayName,
            email: email,
            photourl: photoUrl,
            age: 0,
            doctors: [],
            patients: [],
            relatives: [],
            phoneNumber: '',
            gender: '',
            dateOfBirth: '',
            location: "",
            fcmtoken: "",
            addtime: Timestamp.now(),
          );

          await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userdata, options) =>
                    userdata.toFirestore(),
              )
              .add(data);
        }
        await FirebaseMessagingApi.updateFcmTokenInFirestore(id);

        // Show loading spinner

        // Navigate to the next page after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          Get.back(); // Close the loading spinner
          Get.offAndToNamed(AppRoutes.Application);
        });
        log('đăng nhâp thành công');
      }
    } catch (e) {
      // Replace with a proper error handling mechanism
      log("Login error: $e");
      Get.snackbar(
        "Lỗi",
        "Có lỗi xảy ra khi đăng nhập, vui lòng thử lại sau",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    finally{
      EasyLoading.dismiss();
    }
  }

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently logged out");
      } else {
        print("User is logged in");
      }
    });
  }
}
