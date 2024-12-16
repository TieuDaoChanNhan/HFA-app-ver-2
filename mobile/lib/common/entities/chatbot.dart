import 'package:cloud_firestore/cloud_firestore.dart';

class ChatbotEntity {
  String? role;
  String? id;
  String? uid;
  String? content;
  Timestamp? timestamp;
  String? image;

  ChatbotEntity({
    this.role,
    this.id,
    this.uid,
    this.content,
    this.timestamp,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'content': content,
      'timestamp': timestamp,
      'image': image,
      'role': role,
    };
  }

  factory ChatbotEntity.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ChatbotEntity(
      id: doc.id,
      uid: data['uid'],
      content: data['content'],
      timestamp: data['timestamp'],
      image: data['image'],
      role: data['role'],
    );
  }

  @override
  String toString() {
    return 'ChatbotEntity{id: $id, uid: $uid, content: $content, timestamp: $timestamp, image: $image, role: $role}';
  }
}
