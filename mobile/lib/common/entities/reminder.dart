import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  String? id;
  List<bool>? onDay;
  String? name;
  String? note;
  List<int>? measureMedId; // Changed from List<String> to List<int>
  List<String>? prescriptionId;
  String? time;
  String? date;
  int? numDate; // New field for numDate
  String? userId; // New field for userId

  Reminder({
    this.id,
    this.onDay,
    this.name,
    this.note,
    this.measureMedId,
    this.prescriptionId,
    this.time,
    this.date,
    this.numDate, // Include in constructor
    this.userId, // Include in constructor
  });

  factory Reminder.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Reminder(
      id: snapshot.id,
      onDay: (data?['onDay'] as List<dynamic>?)
          ?.map((item) => item as bool)
          .toList(),
      name: data?['name'],
      note: data?['note'],
      time: data?['time'],
      date: data?['date'],
      measureMedId: (data?['measureMedId'] as List<dynamic>?)
          ?.map((item) => item as int) // Map to List<int>
          .toList(),
      prescriptionId: (data?['prescriptionId'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      numDate: data?['numDate'] as int?, // Map numDate from Firestore
      userId: data?['userId'] as String?, // Map userId from Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'onDay': onDay,
      'name': name,
      'note': note,
      'time': time,
      'date': date,
      'measureMedId': measureMedId, // Now a List<int>
      'prescriptionId': prescriptionId,
      'numDate': numDate, // Include numDate in JSON map
      'userId': userId, // Include userId in JSON map
    };
  }

  @override
  String toString() {
    return 'Reminder{id: $id, onDay: $onDay, name: $name, note: $note, measureMedId: $measureMedId, prescriptionId: $prescriptionId, time: $time, date: $date, numDate: $numDate, userId: $userId}'; // Include userId in toString
  }
}
