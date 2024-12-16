import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';

class ConnectHardwareState {
  RxList<int> medId = <int>[].obs;
  RxList<List<double>> medIndex = <List<double>>[].obs;
  RxList<String> medValue = <String>[].obs;
  RxList<String> medDate = <String>[].obs;
  RxList<String> medTime = <String>[].obs;
  RxList<DateTime> medPass = <DateTime>[].obs;
  var profile = Rx<UserData?>(null);
}
