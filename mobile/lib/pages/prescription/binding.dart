import 'package:get/get.dart';
import 'package:health_for_all/pages/choose_type_med/controller.dart';
import 'package:health_for_all/pages/prescription/controller.dart';

class PrescriptionBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrescriptionController(),fenix: true);
    Get.lazyPut(() => ChooseTypeMedController(),fenix: true);
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => PostController());
    // Get.lazyPut(()=> ProfileController());
    // Get.lazyPut(()=> TextWithImageController());
  }
}
