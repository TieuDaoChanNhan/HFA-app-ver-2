import 'package:get/get.dart';
import 'package:health_for_all/common/entities/comment.dart';
import 'package:health_for_all/common/entities/diagnostic.dart';

class TypeMedicalHistoryState {
  RxList<Comment> commmentList = <Comment>[].obs;
  RxList<Diagnostic> diagnosticList = <Diagnostic>[].obs;
}
