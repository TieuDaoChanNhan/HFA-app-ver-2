import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FirebaseApi {
  FirebaseApi._();
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final db = FirebaseFirestore.instance;

  static Future<QuerySnapshot<Map<String, dynamic>>> getQuerySnapshot(
      String collection, String field, String value) async {
    final querySnapshot =
        await db.collection(collection).where(field, isEqualTo: value).get();
    return querySnapshot;
  }

  // Truy vấn và lấy `docID` của tài liệu dựa trên giá trị trường cụ thể
  static Future<String?> getDocumentId(
      String collection, String field, String value) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final querySnapshot =
          await db.collection(collection).where(field, isEqualTo: value).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        print('No document found with $field: $value');
        return null;
      }
    } catch (e) {
      print('Error retrieving document ID: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<bool?> checkExistDocumentForMed(
      String collection,
      String field1,
      String value1,
      String field2,
      String value2,
      String field3,
      Timestamp value3) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final querySnapshot = await db
          .collection(collection)
          .where(field1, isEqualTo: value1)
          .where(field2, isEqualTo: value2)
          .where(field3, isEqualTo: value3)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        print('No document found with $field1: $value1');
        return false;
      }
    } catch (e) {
      print('Error retrieving document ID: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentSnapshotById(
      String collection, String docId) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final docSnapshot = await db.collection(collection).doc(docId).get();
      if (docSnapshot.exists) {
        return docSnapshot;
      } else {
        throw Exception('No document found with ID: $docId');
      }
    } catch (e) {
      throw Exception('Error retrieving document snapshot: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final docRef = db.collection(collection).doc(documentId);
      await docRef.update(data);
      print('Document $documentId updated successfully in $collection.');
    } catch (e) {
      print('Error updating document: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<void> deleteDocument(
      String collection, String documentId) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final docRef = db.collection(collection).doc(documentId);
      await docRef.delete();
      print('Document $documentId deleted successfully from $collection.');
    } catch (e) {
      print('Error deleting document: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<bool> addValueToArrayField(
      String collection, String id, String fieldName, String valueToAdd) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final querySnapshot = await getQuerySnapshot(collection, 'id', id);
      if (querySnapshot.docs.isEmpty) {
        print('No document found with id: $id');
        return false;
      }

      final docId = querySnapshot.docs.first.id;
      final docRef = db.collection(collection).doc(docId);

      await docRef.update({
        fieldName: FieldValue.arrayUnion([valueToAdd]),
      });

      print('Value added to array field $fieldName in document $docId.');
      return true;
    } catch (e) {
      print('Error adding value to array field: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<bool> removeValueFromArrayField(String collection, String id,
      String fieldName, String valueToRemove) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final querySnapshot = await getQuerySnapshot(collection, 'id', id);
      if (querySnapshot.docs.isEmpty) {
        print('No document found with id: $id');
        return false;
      }

      final docId = querySnapshot.docs.first.id;
      final docRef = db.collection(collection).doc(docId);

      await docRef.update({
        fieldName: FieldValue.arrayRemove([valueToRemove]),
      });

      print('Value removed from array field $fieldName in document $docId.');
      return true;
    } catch (e) {
      print('Error removing value from array field: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<List<Map<String, dynamic>>> getAllDocuments(
      String collectionName) async {
    try {
      // Truy vấn tất cả các document trong collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      // Chuyển đổi kết quả thành một danh sách các Map (dữ liệu JSON)
      List<Map<String, dynamic>> documents = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return documents; // Trả về danh sách các documents
    } catch (e) {
      print('Lỗi khi lấy documents: $e');
      return [];
    }
  }

  static Future addDocument(
      String collection, Map<String, dynamic> data) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      final docRef = await db.collection(collection).add(data);
      print('Document added successfully to $collection.');
      return docRef.id;
    } catch (e) {
      print('Error adding document: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  static Future<String?> uploadImage(
      String imagePath, String folderPath) async {
    try {
      EasyLoading.show(status: "Đang xử lí...");
      File file = File(imagePath);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('$folderPath/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // static Future updateDocument(
  //     String collection, String documentId, Map<String, dynamic> data) async {
  //   try {
  //     final docRef = db.collection(collection).doc(documentId);
  //     await docRef.update(data);
  //     log('Document $documentId updated successfully in $collection.');
  //   } catch (e) {
  //     log('Error updating document: $e');
  //   }
  // }
}
