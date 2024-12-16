import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  String? name;
  String? description;
  int? quantity;
  Timestamp? timeDrinking;
  String? id;
  String? unit;
  String? medicineBaseId;

  Medicine(
      {this.name,
      this.description,
      this.quantity,
      this.timeDrinking,
      this.id,
      this.unit,
      this.medicineBaseId});

  factory Medicine.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final json = snapshot.data();
    if (json == null) {
      throw Exception('Document does not exist');
    }
    return Medicine(
        name: json['name'] as String? ?? '',
        description: json['description'] as String? ?? '',
        quantity: json['quantity'] as int? ?? 0,
        id: json['id'] as String? ?? '',
        timeDrinking: json['timeDrinking'] != null
            ? Timestamp.fromMillisecondsSinceEpoch(json['timeDrinking'])
            : Timestamp.now(),
        medicineBaseId: json['medicineBaseId'] as String? ?? '',
        unit: json['unit'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'id': id,
      'timeDrinking': timeDrinking?.millisecondsSinceEpoch,
      'unit': unit,
      'medicineBaseId': medicineBaseId
    };
  }

  @override
  String toString() {
    return 'Medicine{name: $name, description: $description, quantity: $quantity, timeDrinking: $timeDrinking, id: $id, unit: $unit, medicineBaseId: $medicineBaseId}';
  }
}
