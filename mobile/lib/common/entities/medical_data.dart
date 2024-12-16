import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalEntity {
  String? id;
  String? typeId;
  Timestamp? time;
  String? value;
  List<String>? imageUrls;
  List<String>? commentIds;
  List<String>? dianoticIds;
  String? userId;
  String? unit;
  String? note;
  List<String>? imagePaths;
  List<String>? index; // New field for index

  MedicalEntity({
    this.commentIds,
    this.userId,
    this.dianoticIds,
    this.imageUrls,
    this.id,
    this.time,
    this.typeId,
    this.value,
    this.unit,
    this.note,
    this.imagePaths,
    this.index, // Added to constructor
  });

  @override
  String toString() {
    return 'MedicalEntity{id: $id, typeId: $typeId, time: $time, value: $value, imageUrls: $imageUrls, commentIds: $commentIds, dianoticIds: $dianoticIds, userId: $userId, unit : $unit, note: $note, imagePaths: $imagePaths, index: $index}';
  }

  factory MedicalEntity.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return MedicalEntity(
      id: snapshot.id,
      typeId: data?['typeId'] as String?,
      time: data?['time'] as Timestamp?,
      value: data?['value'] as String?,
      imageUrls: (data?['imageUrls'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      commentIds: (data?['commentIds'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      dianoticIds: (data?['dianoticIds'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      userId: data?['userId'] as String?,
      unit: data?['unit'] as String?,
      note: data?['note'] as String?,
      imagePaths: (data?['imagePaths'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      index: (data?['index'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(), // Added to handle index field
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      if (id != null) 'id': id,
      if (typeId != null) 'typeId': typeId,
      if (time != null) 'time': time,
      if (value != null) 'value': value,
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (commentIds != null) 'commentIds': commentIds,
      if (dianoticIds != null) 'dianoticIds': dianoticIds,
      if (userId != null) 'userId': userId,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (imagePaths != null) 'imagePaths': imagePaths,
      if (index != null) 'index': index, // Added to Firestore map
    };
  }
}
