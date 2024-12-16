import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/comment.dart';
import 'package:health_for_all/common/entities/ecg_entity.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/common/helper/datetime_change.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/graph_data_page/state.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';
import 'package:intl/intl.dart';

class EcgDataController extends GetxController {
  final medicalController = Get.find<OverallMedicalDataHistoryController>();
  final state = EcgHistoryDataState();
  final appController = Get.find<ApplicationController>();
  RxMap<String, List<MedicalEntity>> result =
      <String, List<MedicalEntity>>{}.obs;
  Rx<DateTime> rangeStart = DateTime.now().obs;
  Rx<DateTime> rangeEnd = DateTime.now().obs;

  Future<String> getUser(String userId) async {
    final db = FirebaseFirestore.instance;
    final querySnapshot =
        await db.collection("users").where('id', isEqualTo: userId).get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = await querySnapshot.docs.first.reference.get();
      final userData = UserData.fromFirestore(docSnapshot, null);
      return userData.name!;
    }
    return '';
  }

  Future fetchEventsInDay(DateTime date, String value, int? limit) async {
    final db = FirebaseFirestore.instance;
    final List<MedicalEntity> data = [];
    try {
      EasyLoading.show(status: "Đang xử lí...");

      // Xác định khoảng thời gian của ngày
      final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
      final endOfDay =
          DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

      // Chuyển đổi DateTime thành Timestamp
      final startTimestamp = Timestamp.fromDate(startOfDay);
      final endTimestamp = Timestamp.fromDate(endOfDay);

      // Lấy typeId từ Firestore bằng giá trị trường 'name'
      final query = await FirebaseApi.getQuerySnapshot(
          'type_medical_data', 'name', value);
      final docs = query.docs;

      if (docs.isEmpty) {
        // Không tìm thấy tài liệu với 'name' là specificValue
        return null;
      }

      final typeId = docs.first.id;
      // log("start: ${startOfDay}");
      // log("end: ${endOfDay}");

      // Tìm tài liệu từ collection 'medicalData' với typeId và userId
      // Và lọc theo thời gian trong ngày
      final querySnapshot = await db
          .collection('medicalData')
          .where('typeId', isEqualTo: typeId)
          .where('userId',
              isEqualTo: appController.state.selectedUserId.value != ""
                  ? appController.state.selectedUserId.value
                  : medicalController.appController.state.profile.value?.id)
          .where('time',
              isGreaterThanOrEqualTo:
                  startTimestamp) // Lọc tài liệu với 'time' >= startOfDay
          .where('time',
              isLessThanOrEqualTo:
                  endTimestamp) // Lọc tài liệu với 'time' <= endOfDay
          .orderBy('time', descending: true) // Sắp xếp theo 'time' giảm dần
          .limit(limit ??
              1) // Giới hạn kết quả để lấy tài liệu muộn nhất trong ngày
          .get();

      final documents = querySnapshot.docs;

      if (documents.isEmpty) {
        // Không tìm thấy tài liệu phù hợp trong ngày
        return null;
      }

      // Chuyển đổi dữ liệu tài liệu thành đối tượng MedicalEntity
      for (final doc in documents) {
        data.add(MedicalEntity.fromFirestore(doc, null));
      }
      result[DateFormat('dd/MM/yyyy').format(date)] = data;
    } catch (e) {
      // Xử lý lỗi
      print('Error fetching event in day: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future fetchEventAmountTime(String value) async {
    log('fetchEventAmountTime: $value');
    log('rangeStart: ${rangeStart.value}');
    log('rangeEnd: ${rangeEnd.value}');
    log('Duration: ${DatetimeChange.getDuration(rangeEnd.value, rangeStart.value)}');
    DateTime temp = rangeStart.value;
    for (int i = 0;
        i <= DatetimeChange.getDuration(rangeEnd.value, rangeStart.value);
        i++) {
      await fetchEventsInDay(temp, value, 100);
      temp = temp.add(const Duration(days: 1));

      log(result.toString());
    }
  }
}
