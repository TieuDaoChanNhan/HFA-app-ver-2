import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:health_for_all/common/entities/user.dart';
import 'package:health_for_all/pages/following_medical_data/state.dart';

class FollowingMedicalDataController extends GetxController {
  // final followingController = Get.find<FollowingController>();
  final state = FollowingMedicalDataState();
  Future<UserData> getUser(String userId) async {
    final db = FirebaseFirestore.instance;
    final querySnapshot =
        await db.collection("users").where('id', isEqualTo: userId).get();
    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = await querySnapshot.docs.first.reference.get();
      final userData = UserData.fromFirestore(docSnapshot, null);
      return userData;
    }
    return UserData();
  }
}
