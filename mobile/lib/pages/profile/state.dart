import 'package:get/get.dart';

class ProfileState {
  var id = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var phoneNumber = '123456789'.obs;
  var dateOfBirth = '01/01/2000'.obs;
  var gender = 'Nam'.obs;

  var searchResults = <Map<String, dynamic>>[].obs;
  var hasText = false.obs;
}
