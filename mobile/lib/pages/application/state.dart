// import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
// import 'package:do_an_tot_nghiep_final/common/entities/user.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';

class ApplicationState {
  final _page = 0.obs;
  int get page => _page.value;
  set page(value) => _page.value = value;
  var head_detail = Rx<UserLoginResponseEntity?>(null);
  var profile = Rx<UserData?>(null);
  RxInt age = 0.obs;
  RxString updateTime = ''.obs;
  RxMap<String, dynamic> medicalData = <String, dynamic>{}.obs;
  RxInt updateMedData = 0.obs;
  RxString selectedUserId = ''.obs;
  Rx<UserData> selectedUser = UserData().obs;
  // var user = Rxn<UserDB>();
}
