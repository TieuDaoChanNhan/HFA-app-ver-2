import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';

class PrescriptionState {
  var profile = Rx<UserData?>(null);
  var del = true.obs;
  var num_prescription = 0.obs;
}