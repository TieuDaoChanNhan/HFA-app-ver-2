import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/request_follow.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/entities/user_request.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/profile/index.dart';
import 'package:intl/intl.dart';

class ProfileController extends GetxController {
  final state = ProfileState();
  final appController = Get.find<ApplicationController>();

  DateTime parseDate(String dateString) {
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return dateFormat.parse(dateString);
  }

  Future<List<String>> getUserIdsFromDocument(String field) async {
    final docId = await FirebaseApi.getDocumentId(
        'users', 'id', appController.state.profile.value!.id!);
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(docId).get();
    List<dynamic> ids = doc.get(field);
    return ids.map((id) => id.toString()).toList();
  }

  int calculateAge(String dateString) {
    DateTime today = DateTime.now();
    final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    final birthDate = dateFormat.parse(dateString);
    int age = today.year - birthDate.year;

    // Nếu ngày sinh chưa qua trong năm nay
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<List<UserData>> fetchUserByIds(List<String> id) async {
    List<UserData> users = [];
    final db = FirebaseFirestore.instance;

    for (String userId in id) {
      final querySnapshot =
          await db.collection("users").where('id', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        final docSnapshot = await querySnapshot.docs.first.reference.get();
        final userData = UserData.fromFirestore(docSnapshot, null);
        users.add(userData);
      }
    }
    return users;
  }

  Stream<List<UserData>> getUserByIds(List<String> id) async* {
    while (true) {
      yield await fetchUserByIds(id);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<List<UserRequest>> fetchRequest() async {
    List<UserRequest> requests = [];

    try {
      // EasyLoading.show(status: "Đang xử lí...");
      // Lấy danh sách các yêu cầu từ Firestore
      final querySnapshot = await FirebaseApi.getQuerySnapshot(
          'requestFollows', 'toUId', appController.state.profile.value!.id!);

      // Lưu danh sách các Future<UserRequest>
      final List<Future<UserRequest>> requestFutures = [];

      for (var doc in querySnapshot.docs) {
        final data = RequestFollow.fromFirestore(doc, null);

        // Thực hiện truy vấn để lấy profile người dùng
        final profileFuture =
            FirebaseApi.getQuerySnapshot('users', 'id', data.fromUId!);

        // Tạo Future<UserRequest> cho mỗi tài liệu
        requestFutures.add(profileFuture.then((queryProfile) {
          // Kiểm tra xem có ít nhất một tài liệu không
          if (queryProfile.docs.isNotEmpty) {
            final request = UserRequest.fromFirestore(
                queryProfile.docs.first, null, data.typeRole!, doc.id);
            return request;
          } else {
            throw Exception('User profile not found for ${data.fromUId}');
          }
        }));
      }

      // Đợi tất cả các Future<UserRequest> hoàn thành
      requests = await Future.wait(requestFutures);
    } catch (e) {
      print('Error fetching requests: $e');
    }
    // finally{
    //   EasyLoading.dismiss();
    // }
    for (var i in requests) {
      print("name: " + i.user!.name.toString() + 'role : ' + i.role.toString());
    }
    return requests;
  }

  Stream<List<UserRequest>> getRequest() async* {
    while (true) {
      yield await fetchRequest();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> updateUserDataById(String id, UserData userData) async {
    final db = FirebaseFirestore.instance;

    // Tìm document có trường id trùng với id truyền vào
    final querySnapshot =
        await db.collection("users").where('id', isEqualTo: id).get();

    if (querySnapshot.docs.isNotEmpty) {
      final docRef = querySnapshot.docs.first.reference;

      // Cập nhật dữ liệu
      await docRef.update(userData.toFirestore());
      print("User data updated successfully.");
    } else {
      print("User with the given id not found.");
    }
  }

  Future sendRequest(String id, String type) async {
    log('send request');
    final db = FirebaseFirestore.instance;
    final userbase = await db
        .collection("requestFollows")
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userdata, options) => userdata.toFirestore(),
        )
        .where("from_uid", isEqualTo: appController.state.profile.value!.id)
        .where("to_uid", isEqualTo: id)
        .where('typeRole', isEqualTo: type)
        .get();

    if (userbase.docs.isEmpty) {
      final data = RequestFollow(
        fromUId: appController.state.profile.value!.id,
        toUId: id,
        typeRole: type,
      );
      log(data.toString());

      await db
          .collection('requestFollows')
          .withConverter(
            fromFirestore: RequestFollow.fromFirestore,
            toFirestore: (RequestFollow request, options) =>
                request.toFirestore(),
          )
          .add(data);
      log('send request successfully');
      Get.back();
    }
  }
}
