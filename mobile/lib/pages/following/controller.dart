import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/following/state.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';

class FollowingController extends GetxController {
  final appController = Get.find<ApplicationController>();
  final state = FollowingState();
  final overallMedicalDataHistoryController =
      Get.find<OverallMedicalDataHistoryController>();
  Map<dynamic, int> alarmCountMap = <String, int>{}.obs;
  Map<String, String> updatedTimeMap = <String, String>{}.obs;
  Future getAlarmCount(String id) async {
    final alarmCount = await FirebaseFirestore.instance
        .collection('notifications')
        .where('to_uid', isEqualTo: id)
        .where('status', isEqualTo: 'alarm')
        .get()
        .then((snapshot) => snapshot.docs.length);
    log('Alarm count: $alarmCount');
    alarmCountMap[id] = alarmCount;
  }

  Future<void> fetchRelatives(String userId) async {
    final relatives = await FirebaseApi.getQuerySnapshot('users', 'id', userId);
    state.relatives = relatives.docs
        .map((doc) => UserData.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>, null))
        .toList();

    // log('Unread: ${state.unread.value}, Read: ${state.read.value}, Importance: ${state.importance.value}');
  }

  Future getUpdatedDataTime(String id) async {
    final db = FirebaseFirestore.instance;

    try {
      EasyLoading.show(status: "Đang xử lí...");

      // Chuyển đổi DateTime thành Timestamp
      final time = Timestamp.fromDate(DateTime.now());

      // Tìm tài liệu từ collection 'medicalData' với typeId và userId
      // Và lọc theo thời gian trong ngày
      final querySnapshot = await db
          .collection('medicalData')
          .where('userId',
              isEqualTo: id) // Lọc tài liệu với 'time' >= startOfDay
          .where('time',
              isLessThanOrEqualTo: time) // Lọc tài liệu với 'time' <= endOfDay
          .orderBy('time', descending: true) // Sắp xếp theo 'time' giảm dần
          .limit(1) // Giới hạn kết quả để lấy tài liệu muộn nhất trong ngày
          .get();
      final documents = querySnapshot.docs;
      if (documents.isEmpty) {
        // Không tìm thấy tài liệu phù hợp trong ngày
        updatedTimeMap[id] = 'Chưa cập nhật dữ liệu';
      }
      log(documents.first.toString());
      // Chuyển đổi dữ liệu tài liệu thành đối tượng MedicalEntity
      final data = documents.first.data();
      log(data.toString());
      updatedTimeMap[id] =
          '${DatetimeChange.getHourString(data['time'].toDate())} ${DatetimeChange.getDatetimeString(data['time'].toDate())}';
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching updated time $e');
      return 'Lỗi';
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future getFollowingData(String id) async {
    await getAlarmCount(id);
    await getUpdatedDataTime(id);
  }

  @override
  void onInit() {
    super.onInit();
    appController.state.profile.value?.relatives?.forEach((id) {
      getFollowingData(id);
    });
    appController.state.profile.value?.patients?.forEach((id) {
      getFollowingData(id);
    });
  }

  @override
  void onClose() {
    overallMedicalDataHistoryController.dispose();
    super.onClose();
  }
}
