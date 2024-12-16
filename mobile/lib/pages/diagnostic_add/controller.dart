import 'dart:developer';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/API/item.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/pages/application/controller.dart';
import 'package:health_for_all/pages/diagnostic_add/information.dart';
import 'package:health_for_all/pages/diagnostic_add/widget/data_box.dart';
import 'package:intl/intl.dart';

class DiagnosticAddController extends GetxController {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final noteController = TextEditingController();
  final unitController = TextEditingController();
  final valueController = TextEditingController();
  final appController = Get.find<ApplicationController>();
  final RxList<XFile> selectedFiles = <XFile>[].obs;
  final RxList<String> selectedImagesURL = <String>[].obs;
  static int length = 5;
  XFile? xfile;
  // Dữ liệu fix cứng do chưa thể tạo List medical Data
  final List<bool> checkboxStates = List.filled(10, false);

  Future addDiagnostic(String medicalId, String toUId) async {
    final data = Diagnostic(
      content: noteController.text,
      timestamp: Timestamp.fromDate(DateTime.now()),
      fromUId: appController.state.profile.value!.id!,
      toUId: toUId,
      medicalId: medicalId,
      imageURL: selectedImagesURL,
      status: 'unread',
    );
    final docId = await FirebaseApi.addDocument('diagnostic', data.toMap());
    return docId;
  }

  Future<void> addImage() async {
    for (var value in selectedFiles) {
      final imageUrl = await FirebaseApi.uploadImage(value.path, 'diagnostic');
      selectedImagesURL.add(imageUrl!);
      log(value.toString());
      log(selectedImagesURL.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  DateTime datetime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  String formatTimeOfDay() {
    TimeOfDay timeOfDay = TimeOfDay.now();
    String formattedTime =
        "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
    return formattedTime; // In ra thời gian dưới dạng chuỗi "hh:mm"
  }

  List<DataBox> get entries => List.generate(length, (index) {
        return DataBox(
          time: formatTimeOfDay(),
          noteController: noteController,
          leadingiconpath: Item.getIconPath(ind[index]),
          title: Item.getTitle(ind[index]),
          value: Item.getUnit(ind[index]),
          unit: Item.getUnit(ind[index]),
          pos: index,
        );
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
      updateTimestamp(); // Cập nhật timestamp
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: timeOfDay,
    );

    if (selectedTime != null) {
      timeOfDay = selectedTime;
      final formattedTime = selectedTime.format(context);
      timeController.text = formattedTime;
      updateTimestamp(); // Cập nhật timestamp
    }
  }

  // Future<void> updatechosenuser(UserData x) async {
  //   chosenuser = x;
  // }

  Timestamp updateTimestamp() {
    final updatedDateTime = DateTime(
      datetime.year,
      datetime.month,
      datetime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    final finalDateTime = updatedDateTime.copyWith(second: 0, millisecond: 0);

    // Định dạng DateTime thành chuỗi
    final formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(finalDateTime);
    final dateTimestamp = Timestamp.fromDate(finalDateTime);
    // In ra hoặc làm gì đó với formattedDateTime
    return dateTimestamp;
  }

  Future<XFile?> urlToFile(String imageUrl) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      // Step 1: Download the image data from the URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Step 2: Get the temporary directory to save the image
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/image.jpg';

        // Step 3: Write the downloaded bytes to a file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Step 4: Convert the file path to XFile
        return XFile(file.path);
      } else {
        throw Exception('Failed to download image');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
    finally{
      EasyLoading.dismiss();
    }
  }
}
