import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String? id;
  final String uid;
  final String content;
  final Timestamp time;
  final String medicalId;

  Comment({
    this.id,
    required this.uid,
    required this.content,
    required this.time,
    required this.medicalId,
  });

  @override
  String toString() {
    return 'Comment('
        'id: $id, '
        'uid: $uid, '
        'content: $content, '
        'time: $time, '
        'medicalId: $medicalId'
        ')';
  }

  factory Comment.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Comment(
        id: snapshot.id,
        uid: data?['uid'] as String,
        content: data?['content'] as String,
        time: data?['time'] != null
            ? Timestamp.fromMillisecondsSinceEpoch(data?['time'])
            : Timestamp.now(),
        medicalId: data?['medicalId'] as String);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'uid': uid,
      'content': content,
      'time': time.millisecondsSinceEpoch,
      'medicalId': medicalId,
    };
  }
}
