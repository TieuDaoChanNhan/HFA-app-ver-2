import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:image_picker/image_picker.dart';

class MedicalDataState {
  RxString bloodPressureValue = "120/80".obs;
  Rx<TimeOfDay> timeofDay = TimeOfDay.now().obs;
  RxMap<String, MedicalEntity> data = <String, MedicalEntity>{}.obs;
  Rx<XFile?> selectedFile = Rx<XFile?>(null);
}
