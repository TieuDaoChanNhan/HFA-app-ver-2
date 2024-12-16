import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/ecg_entity.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/samsung_connect/state.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:intl/intl.dart';

class SamsungConnectController extends GetxController {
  DateTime start = DateTime.now().add(const Duration(hours: 1));
  DateTime end = DateTime.now().add(const Duration(hours: 1));
  final state = SamsungConnectState();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final appController = Get.find<ApplicationController>();

  Future<void> selectDateStart(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      start = selectedDate;
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      startDateController.text = formattedDate;
    }
  }

  Future<void> selectDateEnd(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: start,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      end = selectedDate;
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      endDateController.text = formattedDate;
    }
  }

  Future syncMedData(DateTime time, String typeId, String value, String unit,
      BuildContext context) async {
    Get.dialog(const Center(child: CircularProgressIndicator()));

    final data = MedicalEntity(
      userId: appController.state.profile.value?.id,
      time: Timestamp.fromDate(time),
      typeId: typeId,
      value: value,
      unit: unit,
    );

    log(data.toString());
    await FirebaseApi.addDocument("medicalData", data.toFirestoreMap());
    checkAlarms(data.toFirestoreMap());
    appController.getUpdatedLatestMedical();
    // isLoading = false.obs;
    Get.back();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Đã đồng bộ dữ liệu'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back(); // Dismiss the dialog
              },
              child: const Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  Future checkAlarms(Map<String, dynamic> data) async {
    try {
      log("gửi");
      // Truy vấn tất cả các document trong collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('alarms').where('userId', isEqualTo: appController.state.profile.value!.id).get();

      // Chuyển đổi kết quả thành một danh sách các Map (dữ liệu JSON)
      List<Map<String, dynamic>> documents = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      int typeId = int.parse(data["typeId"]);
      for (var i in documents) {
        if (i['enable'] == false) continue;
        if (data["typeId"] != i["typeId"]) continue;
        int low = int.parse(i["lowThreshold"]);
        int high = int.parse(i["highThreshold"]);
        if (typeId == 0) {
          String value = data['value'];
          List<String> parts = value.split('/');
          int systolic = int.parse(parts[0]);
          int diastolic = int.parse(parts[1]);
          value = i['highThreshold'];
          parts = value.split('/');
          int highSystolic = int.parse(parts[0]);
          int highDiastolic = int.parse(parts[1]);
          value = i['lowThreshold'];
          parts = value.split('/');
          int lowSystolic = int.parse(parts[0]);
          int lowDiastolic = int.parse(parts[1]);
          if (systolic<lowSystolic||systolic>highSystolic||diastolic<lowDiastolic||diastolic>highDiastolic) sendAlarm(typeId, value);
        } else {
          int value = int.parse(data['value']);
          if (value < low || value > high) sendAlarm(typeId, value.toString());
        }
      }
    } catch (e) {
      print('Lỗi khi lấy documents: $e');
      return [];
    }
  }

  void sendAlarm(int type, String value) {
    FirebaseMessagingApi.sendMessage(
      appController.state.profile.value!.fcmtoken!,
      'Cảnh báo',
      "Chỉ số ${Item.getTitle(type)} $value ${Item.getUnit(type)} của bạn đang ở ngoài ngưỡng an toàn",
      'alarm',
      '/alarm',
      appController.state.profile.value!.id!,
      'alarm',
    );
  }
}
