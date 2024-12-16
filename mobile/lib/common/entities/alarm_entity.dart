import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmEntity {
  String? id;
  String? typeId;
  Timestamp? time;
  String? highThreshold;
  String? lowThreshold;
  String? userId;
  bool? enable;

  AlarmEntity(
      {this.id,
      this.typeId,
      this.time,
      this.highThreshold,
      this.lowThreshold,
      this.userId,
      this.enable});

  @override
  String toString() {
    return 'AlarmEntity{id: $id, typeId: $typeId, time: $time, highThreshold: $highThreshold, lowThreshold: $lowThreshold, userId: $userId, enable: $enable}';
  }

  factory AlarmEntity.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return AlarmEntity(
      id: snapshot.id,
      typeId: data?['typeId'] as String?,
      time: data?['time'] as Timestamp?,
      highThreshold: data?['highThreshold'] as String?,
      lowThreshold: data?['lowThreshold'] as String?,
      userId: data?['userId'] as String?,
      enable: data?['enable'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'typeId': typeId,
      'time': time,
      'highThreshold': highThreshold,
      'lowThreshold': lowThreshold,
      'userId': userId,
      'enable': enable,
    };
  }
}
