import 'package:get/get.dart';
import 'package:health_for_all/common/entities/notification_entity.dart';
import 'package:health_for_all/common/entities/user.dart';

class NotificationState {
  RxInt unread = 0.obs;
  RxInt read = 0.obs;
  RxInt alarm = 0.obs;
  RxInt reminder = 0.obs;
  RxList<NotificationEntity> notiList = <NotificationEntity>[].obs;
  var profile = Rx<UserData?>(null);
}
