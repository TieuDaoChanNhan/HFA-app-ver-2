import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';

class DiagnosticState {
  RxInt unread = 0.obs;
  RxInt read = 0.obs;
  RxInt importance = 0.obs;
  var profile = Rx<UserData?>(null);
}
