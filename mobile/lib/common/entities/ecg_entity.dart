import 'package:cloud_firestore/cloud_firestore.dart';

class EcgEntity {
  String? id;
  Timestamp? time;
  List<String>? index; // List of indices
  String? value; // New string field
  List<String>? commentIds;
  List<String>? dianoticIds;
  String? userId;
  String? unit;
  String? note;

  EcgEntity({
    this.commentIds,
    this.userId,
    this.dianoticIds,
    this.id,
    this.time,
    this.index, // Updated constructor
    this.value, // New string field
    this.unit,
    this.note,
  });

  @override
  String toString() {
    return 'EcgEntity{id: $id, time: $time, index: $index, value: $value, commentIds: $commentIds, dianoticIds: $dianoticIds, userId: $userId, unit: $unit, note: $note}';
  }

  factory EcgEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return EcgEntity(
      id: snapshot.id,
      time: data?['time'] as Timestamp?,
      index: (data?['index'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      value: data?['value'] as String?, // Retrieve the new string field
      commentIds: (data?['commentIds'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      dianoticIds: (data?['dianoticIds'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      userId: data?['userId'] as String?,
      unit: data?['unit'] as String?,
      note: data?['note'] as String?,
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      if (id != null) 'id': id,
      if (time != null) 'time': time,
      if (index != null) 'index': index,
      if (value != null) 'value': value, // Store the new string field
      if (commentIds != null) 'commentIds': commentIds,
      if (dianoticIds != null) 'dianoticIds': dianoticIds,
      if (userId != null) 'userId': userId,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
    };
  }
}
