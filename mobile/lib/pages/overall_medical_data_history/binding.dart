import 'package:get/get.dart';
import 'package:health_for_all/pages/overall_medical_data_history/controller.dart';

class OverallMedicalDataHistory implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OverallMedicalDataHistoryController());
  }
}