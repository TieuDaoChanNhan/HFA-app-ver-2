import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:health_for_all/common/entities/comment.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';
import 'package:health_for_all/common/entities/medical_data.dart';

class OverrallMedicalDataHistoryState {
  RxMap<DateTime, List<MedicalEntity>> history =
      <DateTime, List<MedicalEntity>>{}.obs;
  List<String> dataType = [];
  RxList<Comment> commmentList = <Comment>[].obs;
  RxList<Diagnostic> diagnosticList = <Diagnostic>[].obs;
  RxInt diagnosticCount = 0.obs;
  RxString medicalId = ''.obs;
  // RxString selectedUserId = ''.obs;
  // Rx<UserData> selectedUser = UserData().obs;
  Rx<MedicalEntity> selectedData = MedicalEntity().obs;
}
