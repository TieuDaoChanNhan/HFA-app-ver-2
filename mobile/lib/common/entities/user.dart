import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? id;
  String? name;
  String? email;
  String? photourl;
  String? location;
  String? fcmtoken;
  Timestamp? addtime;
  int? age;
  String? gender;
  String? phoneNumber;
  List<String>? doctors;
  List<String>? patients;
  List<String>? relatives;
  String? dateOfBirth;
  bool? isDoctor;
  num? rate;

  UserData({
    this.id,
    this.name,
    this.email,
    this.photourl,
    this.location,
    this.fcmtoken,
    this.addtime,
    this.age,
    this.gender,
    this.phoneNumber,
    this.doctors,
    this.patients,
    this.relatives,
    this.dateOfBirth,
    this.isDoctor,
    this.rate,
  });

  @override
  String toString() {
    return 'UserData('
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'photourl: $photourl, '
        'location: $location, '
        'fcmtoken: $fcmtoken, '
        'addtime: $addtime, '
        'age: $age, '
        'doctors: $doctors, '
        'patients: $patients, '
        'relatives: $relatives, '
        'gender: $gender, '
        'phoneNumber: $phoneNumber,'
        'dateOfBirth: $dateOfBirth'
        'isDoctor: $isDoctor'
        'rate: $rate'
        ')';
  }

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      id: data?['id'],
      name: data?['name'],
      email: data?['email'],
      photourl: data?['photourl'],
      location: data?['location'],
      fcmtoken: data?['fcmtoken'],
      addtime: data?['addtime'] as Timestamp,
      age: data?['age'],
      doctors: List<String>.from(data?['doctors'] ?? []),
      patients: List<String>.from(data?['patients'] ?? []),
      relatives: List<String>.from(data?['relatives'] ?? []),
      gender: data?['gender'],
      phoneNumber: data?['phoneNumber'],
      dateOfBirth: data?['dateOfBirth'],
      isDoctor: data?['isDoctor'],
      rate: data?['rating'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (name != null) "name": name,
      if (email != null) "email": email,
      if (photourl != null) "photourl": photourl,
      if (location != null) "location": location,
      if (fcmtoken != null) "fcmtoken": fcmtoken,
      if (addtime != null) "addtime": addtime,
      if (age != null) "age": age,
      if (doctors != null) "doctors": doctors,
      if (patients != null) "patients": patients,
      if (relatives != null) "relatives": relatives,
      if (gender != null) "gender": gender,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (dateOfBirth != null) "dateOfBirth": dateOfBirth,
      "isDoctor": isDoctor ?? false,
      if (rate != null) "rating": rate,
    };
  }
}

class UserLoginResponseEntity {
  String? accessToken;
  String? displayName;
  String? email;
  String? photoUrl;

  UserLoginResponseEntity({
    this.accessToken,
    this.displayName,
    this.email,
    this.photoUrl,
  });

  @override
  String toString() {
    return 'UserLoginResponseEntity{accessToken: $accessToken, displayName: $displayName, email: $email, photoUrl: $photoUrl}';
  }

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        accessToken: json["accessToken"],
        displayName: json["displayName"],
        email: json["userEmail"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "displayName": displayName,
        "userEmail": email,
        "photoUrl": photoUrl,
      };
}
