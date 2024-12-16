import 'package:get/get.dart';
import 'package:health_for_all/pages/samsung_connect/controller.dart';

class SamsungConnectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SamsungConnectController());
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => PostController());
    // Get.lazyPut(()=> ProfileController());
    // Get.lazyPut(()=> TextWithImageController());
  }
}
