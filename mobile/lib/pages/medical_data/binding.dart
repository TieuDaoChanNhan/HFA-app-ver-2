import 'package:get/get.dart';
import 'package:health_for_all/pages/medical_data/controller.dart';

class MedicalDataBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MedicalDataController(),fenix: true);
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => PostController());
    // Get.lazyPut(()=> ProfileController());
    // Get.lazyPut(()=> TextWithImageController());
  }
}
