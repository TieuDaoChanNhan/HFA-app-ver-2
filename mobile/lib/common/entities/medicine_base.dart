import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineBase {
  String? id;
  String? name;
  String? description;
  List<String>? imageURL;
  String? userId; // New field added

  MedicineBase({
    this.id,
    this.name,
    this.description,
    this.imageURL,
    this.userId, // Include userId in the constructor
  });

  factory MedicineBase.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return MedicineBase(
      id: snapshot.id,
      name: data?['name'],
      description: data?['description'],
      imageURL: (data?['imageURL'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      userId: data?['userId'], // Fetch userId from Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageURL': imageURL,
      'userId': userId, // Include userId in the JSON serialization
    };
  }

  @override
  String toString() {
    return 'MedicineBase{id: $id, name: $name, description: $description, imageURL: $imageURL, userId: $userId}';
  }
}
