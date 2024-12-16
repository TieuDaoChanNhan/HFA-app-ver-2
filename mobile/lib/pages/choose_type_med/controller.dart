import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:image_picker/image_picker.dart';

import 'state.dart';

class ChooseTypeMedController extends GetxController {
  final state = ChooseTypeMedState();
  final nameMedicine = TextEditingController();
  final description = TextEditingController();
  final RxList<XFile> selectedFiles = <XFile>[].obs;
  final RxList<String> selectedImagesURL = <String>[].obs;
  // final appController = Get.find<ApplicationController>();

  Future<void> addImage() async {
    for (var value in selectedFiles) {
      final imageUrl = await FirebaseApi.uploadImage(value.path, 'medicine');
      selectedImagesURL.add(imageUrl!);
      log(selectedImagesURL.toString());
    }
  }

  Future addMedicineBase() async {
    log("addMedicineBase");
    final name = nameMedicine.text;
    final desc = description.text;
    print(state.profile.value?.id);
    if (name.isEmpty) {
      Get.snackbar("Lỗi", "Điền đầy đủ thông tin", backgroundColor: Colors.red);
      return;
    }
    await addImage();
    final medicine = MedicineBase(
      name: name,
      description: desc,
      imageURL: selectedImagesURL,
      userId: state.profile.value?.id,
      // userId: appController.state.profile.value!.id,
    );
    log(medicine.toString());
    try {
      EasyLoading.show(status: "Đang xử lí...");
      await FirebaseApi.addDocument("medicineBases", medicine.toJson());
      Get.back();
      Get.snackbar("Thành công", "Thêm thuốc thành công",
          backgroundColor: Colors.green);
    } catch (e) {
      log(e.toString());
      Get.snackbar("Lỗi", "Có lỗi xảy ra khi thêm thuốc",
          backgroundColor: Colors.red);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future delMedicineBase(String documentId) async {
    await FirebaseApi.deleteDocument("medicineBases", documentId);
  }

  void clearData() {
    description.clear();
    nameMedicine.clear();
    selectedFiles.clear();
    selectedImagesURL.clear();
  }
}
