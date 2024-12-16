import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationEntity {
  String? title;
  String? body;
  String? type;
  String? id;
  Timestamp? time;
  String? page;
  String? toUId;
  String? fromUId;
  String? status;
  String? medicalId;
  String? diagnosticId;
  NotificationEntity({
    this.title,
    this.body,
    this.type,
    this.id,
    this.time,
    this.page,
    this.toUId,
    this.fromUId,
    this.status,
    this.medicalId,
    this.diagnosticId,
  });

  @override
  String toString() {
    return 'NotificationEntity{title: $title, body: $body, type: $type, id: $id, time: $time, page: $page, uid: $toUId, from_uid: $fromUId, status: $status,  medicalId: $medicalId, diagnosticId: $diagnosticId}';
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'id': id,
      'time': time,
      'page': page,
      'to_uid': toUId,
      'from_uid': fromUId,
      'status': status,
      'medical_id': medicalId,
      'diagnostic_id': diagnosticId,
    };
  }

  factory NotificationEntity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationEntity(
      title: data['title'],
      body: data['body'],
      type: data['type'],
      id: doc.id,
      time: data['time'],
      page: data['page'],
      toUId: data['to_uid'],
      fromUId: data['from_uid'],
      status: data['status'],
      medicalId: data['medical_id'],
      diagnosticId: data['diagnostic_id'],
    );
  }
}
