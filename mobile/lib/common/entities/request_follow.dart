import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFollow {
  final String? fromUId;
  final String? toUId;
  final String? typeRole;

  RequestFollow({this.fromUId, this.toUId, this.typeRole});

  @override
  String toString() {
    return 'Requestfollow{fromUId: $fromUId, toUId: $toUId, typeRole: $typeRole}';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fromUId': fromUId,
      'toUId': toUId,
      'typeRole': typeRole,
    };
  }

  factory RequestFollow.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return RequestFollow(
      fromUId: data?['fromUId'],
      toUId: data?['toUId'],
      typeRole: data?['typeRole'],
    );
  }
}
