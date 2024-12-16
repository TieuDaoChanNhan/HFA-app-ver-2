import 'package:cloud_firestore/cloud_firestore.dart';

class Diagnostic {
  String? id;
  String? content;
  Timestamp? timestamp;
  String? fromUId;
  String? toUId;
  List<String>? imageURL;
  String? medicalId;
  String? status;

  Diagnostic(
      {this.id,
      this.content,
      this.timestamp,
      this.fromUId,
      this.toUId,
      this.imageURL,
      this.medicalId,
      this.status});

  @override
  String toString() {
    return 'Diagnostic{id: $id, content: $content, timestamp: $timestamp, fromUId: $fromUId, toUId: $toUId, imageURL: $imageURL, medicalId: $medicalId, status: $status}';
  }

  factory Diagnostic.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Diagnostic(
      id: snapshot.id,
      content: data?['content'] as String?,
      timestamp: data?['timestamp'] as Timestamp?,
      fromUId: data?['fromUId'] as String?,
      toUId: data?['toUId'] as String?,
      status: data?['status'] as String?,
      imageURL: (data?['imageURL'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      medicalId: data?['medicalId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'timestamp': timestamp,
      'fromUId': fromUId,
      'toUId': toUId,
      'imageURL': imageURL,
      'medicalId': medicalId,
      'status': status,
    };
  }
}
