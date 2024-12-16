import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/pages/choose_type_med/controller.dart';
import 'package:health_for_all/pages/prescription/state.dart';
import 'package:image_picker/image_picker.dart';

class PrescriptionController extends GetxController {
  PrescriptionController() {
    // Khởi tạo danh sách với 10 phần tử ban đầu, mỗi phần tử là một TextEditingController mới
    doseControllers = List<TextEditingController>.generate(
      10,
      (index) => TextEditingController(),
    ).obs;
  }
  final medicineController = Get.find<ChooseTypeMedController>();
  final state = PrescriptionState();
  RxList<XFile> selectedFiles = <XFile>[].obs;
  final RxList<String> selectedImagesURL = <String>[].obs;
  RxList<TextEditingController> doseControllers = <TextEditingController>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  RxList<String> medId = <String>[].obs;
  List<String> doses = <String>[].obs;
  int sumDose = 0;

  Future<void> addImage() async {
    for (var value in selectedFiles) {
      final imageUrl =
          await FirebaseApi.uploadImage(value.path, 'prescription');
      selectedImagesURL.add(imageUrl!);
      log(selectedImagesURL.toString());
    }
  }

  // Future addMedicine() async {
  //   final data = Precription(
  //     name: nameController.text,
  //     note: noteController.text,
  //     imageURL: selectedImagesURL,
  //   );
  //   log(data.toString());
  //   await FirebaseApi.addDocument("medicines", data.toJson());
  // }

  Future addPrescription(String userId) async {
    doses = doseControllers
        .map((controller) => controller.text.trim())
        .toList(); // Trim the text inputs
    sumDose = 0;

    for (var i in doses) {
      // Ensure that the string is not empty and can be converted to an integer
      if (i.isNotEmpty) {
        try {
          EasyLoading.show(status: "Đang xử lí...");

          sumDose += int.parse(i); // Safely parse the integer
        } catch (e) {
          print(
              'Error parsing dose: $i'); // Log the specific string causing an issue
          continue; // Skip this value and move to the next one
        }
        finally{
      EasyLoading.dismiss();
    }
      }
    }

    // Create the Prescription object with valid data
    final data = Prescription(
      name: nameController.text,
      note: noteController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      medicalIDs: medId,
      imageURL: selectedImagesURL,
      medicineDose: doses,
      sumDose: sumDose,
      files: selectedFiles,
      patientId: userId,
    );

    log(data.toString());
    await FirebaseApi.addDocument("prescriptions", data.toJson());
  }

  Future delPrescription(
    String documentId
  ) async {
    await FirebaseApi.deleteDocument("prescriptions", documentId);
  }

  Future getData(List<String> id) async {
    List<MedicineBase> res = [];
    for (var i in id) {
      final kq = await FirebaseApi.getDocumentSnapshotById("medicineBases", i);
      res.add(MedicineBase.fromFirestore(kq));
    }
    return res;
  }

  void clearData() {
    nameController.clear();
    noteController.clear();
    startDateController.clear();
    endDateController.clear();
    for (var element in doseControllers) {
      element.clear();
    }
    selectedFiles.clear();
    selectedImagesURL.clear();
    medId.clear();
  }

  Future<int> getPrescriptionLength() async {
    // Fetch the collection 'prescriptions' from Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('prescriptions').where('patientId', isEqualTo: state.profile.value?.id).get();

    // Return the number of documents
    return snapshot.docs.length;
  }

  void updatePrescriptionCount() async {
    int length = await getPrescriptionLength();
    state.num_prescription.value = length;
  }
}