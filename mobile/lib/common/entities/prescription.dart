import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Import this package

class Prescription {
  String? id;
  List<String>? medicalIDs;
  String? assignId;
  String? patientId;
  String? name;
  String? note;
  String? startDate;
  String? endDate;
  List<String>? imageURL;
  List<String>? medicineDose;
  int? sumDose;
  List<XFile>? files; // New field for List<XFile>

  Prescription({
    this.id,
    this.medicalIDs,
    this.assignId,
    this.patientId,
    this.name,
    this.note,
    this.startDate,
    this.endDate,
    this.imageURL,
    this.medicineDose,
    this.sumDose,
    this.files, // Include in the constructor
  });

  factory Prescription.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Prescription(
      id: snapshot.id,
      patientId: data?['patientId'],
      sumDose: data?['sumDose'],
      assignId: data?['assignId'],
      name: data?['name'],
      note: data?['note'],
      startDate: data?['startDate'],
      endDate: data?['endDate'],
      imageURL: (data?['imageURL'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      medicalIDs: (data?['medicalIDs'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      medicineDose: (data?['medicineDose'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      files: (data?['files'] as List<dynamic>?)?.map((item) => XFile(item)).toList(), // Parse the new field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'assignId': assignId,
      'name': name,
      'note': note,
      'startDate': startDate,
      'endDate': endDate,
      'imageURL': imageURL,
      'medicineDose': medicineDose,
      'medicalIDs': medicalIDs,
      'sumDose': sumDose,
      'files': files?.map((file) => file.path).toList(), // Convert files to JSON (store file paths)
    };
  }

  @override
  String toString() {
    return 'Prescription{id: $id, medicalIDs: $medicalIDs, assignId: $assignId, patientId: $patientId, name: $name, note: $note, startDate: $startDate, endDate: $endDate, imageURL: $imageURL, medicineDose: $medicineDose, sumDose: $sumDose, files: $files}'; // Include files in the string representation
  }
}
