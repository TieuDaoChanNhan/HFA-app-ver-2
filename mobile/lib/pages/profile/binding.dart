import 'package:get/get.dart';

import 'controller.dart';
import 'page/search_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<SearchingController>(() => SearchingController(), fenix: true);
  }
}
