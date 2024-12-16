import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/medicine_base.dart';
import 'package:health_for_all/common/entities/prescription.dart';
import 'package:health_for_all/common/entities/reminder.dart';
import 'package:health_for_all/pages/reminder/state.dart';
import 'package:intl/intl.dart';

class ReminderController extends GetxController {
  final timeController = TextEditingController();
  final dueDateController = TextEditingController();
  final state = ReminderState();
  List<bool> onDate = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> nameDate = [
    "T2",
    "T3",
    "T4",
    "T5",
    "T6",
    "T7",
    "CN",
  ];
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  RxList<Prescription> prescriptionList = <Prescription>[].obs;
  RxList<Prescription> selectedPrescriptions = <Prescription>[].obs;
  List<String> selectedPrescriptionsId = [];
  List<int> medDataList = [];
  List<int> selectedMedData = [];

  Future getMed(List<String> id) async {
    List<MedicineBase> res = [];
    for (var i in id) {
      final kq = await FirebaseApi.getDocumentSnapshotById("medicineBases", i);
      res.add(MedicineBase.fromFirestore(kq));
    }
    return res;
  }

  Future<void> addReminder(String userId) async {
    selectedPrescriptionsId.clear();
    for (var i in selectedPrescriptions) {
      selectedPrescriptionsId.add(i.id!);
    }

    int tmp = 0;
    for (var i in onDate) {
      if (i == true) tmp++;
    }

    final data = Reminder(
      onDay: onDate,
      name: nameController.text,
      note: noteController.text,
      measureMedId: selectedMedData,
      prescriptionId: selectedPrescriptionsId,
      time: timeController.text,
      date: dueDateController.text,
      numDate: tmp,
      userId: userId,
    );

    log(data.toString());
    await FirebaseApi.addDocument("reminders", data.toJson());
  }

  Future<void> delReminder(
    String documentId
  ) async {
    await FirebaseApi.deleteDocument("reminders", documentId);
  }

  bool checkDate(String saveDate) {
    try {
      // Parse the saveDate string in the format 'dd/mm/yyyy'
      DateTime saveDateTime = DateFormat('dd/MM/yyyy').parse(saveDate);

      // Get the current date without the time part
      DateTime currentDate = DateTime.now();

      // Check if the current date has passed the saveDate
      return !currentDate.isAfter(saveDateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return false; // Return false in case of an error
    }
  }

  Future<void> fetchPrescriptions() async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('prescriptions').where('patientId', isEqualTo: state.profile.value?.id).get();
      prescriptionList.value =
          snapshot.docs.map((doc) => Prescription.fromFirestore(doc)).toList();
    } catch (e) {
      print("Error fetching prescriptions: $e");
    }
    finally{
      EasyLoading.dismiss();
    }
  }

  Future getData(List<String> id) async {
    List<Prescription> res = [];
    for (var i in id) {
      final kq = await FirebaseApi.getDocumentSnapshotById("prescriptions", i);
      res.add(Prescription.fromFirestore(kq));
    }
    return res;
  }

  void fetchMedicalData() {
    medDataList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  }

  void clearData() {
    nameController.clear();
    noteController.clear();
    timeController.clear();
    dueDateController.clear();
    selectedMedData.clear();
    selectedPrescriptions.clear();
    for (int i = 0; i < 7; i++) {
      onDate[i] = false;
    }
  }
}