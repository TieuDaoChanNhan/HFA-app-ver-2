import 'package:get/get.dart';
import 'package:health_for_all/common/entities/alarm_entity.dart';
import 'package:health_for_all/common/entities/user.dart';

class AlarmState {
  var profile = Rx<UserData?>(null);
  RxList<AlarmEntity> alarms = <AlarmEntity>[].obs;
  RxList<AlarmEntity> patientAlarms = <AlarmEntity>[].obs;
}
