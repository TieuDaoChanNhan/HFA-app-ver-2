import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_for_all/common/entities/user.dart';

class UserRequest {
  UserData? user;
  String? role;
  String? docID;

  UserRequest({this.user, this.role, this.docID});

  factory UserRequest.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      String role,
      String? docID) {
    final data = snapshot.data();
    return UserRequest(
      user: data != null ? UserData.fromFirestore(snapshot, options) : null,
      role: role,
      docID: docID,
    );
  }

  @override
  String toString() {
    return 'UserRequest{user: $user, role: $role, docID: $docID}';
  }
}
