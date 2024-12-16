import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_messaging_api.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/pages/application/index.dart';
import 'package:health_for_all/pages/medical_data/state.dart';
import 'package:health_for_all/pages/medical_data/widget/combo_box.dart';
import 'package:intl/intl.dart';

class MedicalDataController extends GetxController {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final appController = Get.find<ApplicationController>();
  final state = MedicalDataState();
  static int length = 10;
  void updateLength() {
    length++;
  }

  @override
  void onInit() {
    super.onInit();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    timeController.text = DateFormat('hh:mm a')
        .format(DateTime.now()); // Use 'hh:mm a' for 12-hour format
  }

  final noteController = TextEditingController();
  final unitController = TextEditingController();
  final valueController = TextEditingController();
  DateTime datetime = DateTime.now();
  Rx<TimeOfDay> timeOfDay = TimeOfDay.now().obs;

  void clearController() {
    noteController.clear();
    unitController.clear();
    valueController.clear();
  }

  List get entries => List.generate(length, (index) {
        return Obx(() => ComboBox(
              time: DateFormat('HH:mm').format(DateTime(
                  0, 0, 0, timeOfDay.value.hour, timeOfDay.value.minute)),
              noteController: noteController,
              unitController: TextEditingController(text: Item.getUnit(index)),
              valueController: valueController,
              leadingiconpath: Item.getIconPath(index),
              title: Item.getTitle(index),
              value: valueController.text.obs,
              unit: Item.getUnit(index).obs,
            ));
      });

  Future<void> selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: datetime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      datetime = selectedDate;
      final formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
      dateController.text = formattedDate;
      updateTimestamp();
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay.value,
    );

    if (selectedTime != null) {
      timeOfDay.value = selectedTime;
      final formattedTime = selectedTime.format(context);
      timeController.text = formattedTime;
      updateTimestamp();
    }
  }

  Timestamp updateTimestamp() {
    final updatedDateTime = DateTime(
      datetime.year,
      datetime.month,
      datetime.day,
      timeOfDay.value.hour,
      timeOfDay.value.minute,
    );

    final finalDateTime = updatedDateTime.copyWith(second: 0, millisecond: 0);

    // Định dạng DateTime thành chuỗi
    final dateTimestamp = Timestamp.fromDate(finalDateTime);
    // In ra hoặc làm gì đó với formattedDateTime
    return dateTimestamp;
  }

  Future<String?> saveImageUrlToFirestore(String imageUrl) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final docRef = FirebaseFirestore.instance.collection('images').doc();
      await docRef.set({
        'url': imageUrl,
        'time': DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        'userID': appController.state.profile.value!.id,
      });
      log('Image URL saved to Firestore');
      return docRef.id; // Trả về ID của tài liệu
    } catch (e) {
      log('Error saving image URL to Firestore: $e');
      return null; // Trả về null nếu có lỗi
    } finally {
      EasyLoading.dismiss();
    }
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
