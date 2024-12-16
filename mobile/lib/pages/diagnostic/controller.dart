import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:health_for_all/common/API/firebase_API.dart';
import 'package:health_for_all/common/entities/medical_data.dart';
import 'package:health_for_all/pages/diagnostic/state.dart';

class DiagnosticController extends GetxController {
  final state = DiagnosticState();
  Future<void> fetchDiagnosticCounts(String userId) async {
    final uid = userId;
    final diagnosticUnreadCount = await FirebaseFirestore.instance
        .collection('diagnostic')
        .where('toUId', isEqualTo: uid)
        .where('status', isEqualTo: 'unread')
        .get()
        .then((snapshot) => snapshot.docs.length);
    state.unread.value = diagnosticUnreadCount;

    final readCount = await FirebaseFirestore.instance
        .collection('diagnostic')
        .where('toUId', isEqualTo: uid)
        .where('status', isEqualTo: 'read')
        .get()
        .then((snapshot) => snapshot.docs.length);
    state.read.value = readCount;
    final importanceCount = await FirebaseFirestore.instance
        .collection('diagnostic')
        .where('toUId', isEqualTo: uid)
        .where('status', isEqualTo: 'importance')
        .get()
        .then((snapshot) => snapshot.docs.length);
    state.importance.value = importanceCount;

    log('Unread: ${state.unread.value}, Read: ${state.read.value}, Importance: ${state.importance.value}');
  }

  Future<String> getNameByUId(String uid) async {
    final user = await FirebaseApi.getQuerySnapshot('users', 'id', uid);
    if (user.docs.isNotEmpty) {
      return user.docs.first['name'] as String;
    } else {
      return 'Unknown';
    }
  }

  Future getData(String id) async {
    MedicalEntity res;
    final kq = await FirebaseApi.getDocumentSnapshotById('medicalData', id);
    res = MedicalEntity.fromFirestore(kq, null);
    return res;
  }
}
