import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  late final SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  String getString(String key) {
    return _prefs.getString(key) ?? '';
  }

  bool getBool(String key) {
    return _prefs.getBool(key) ?? false;
  }

  List<String> getList(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // New methods for user credentials
  Future<void> saveUserCredentials(String email, String accessToken,
      String displayName, String photoUrl) async {
    await _prefs.setString('userEmail', email);
    await _prefs.setString('accessToken', accessToken);
    await _prefs.setString('displayName', displayName);
    await _prefs.setString('photoUrl', photoUrl);
  }

  Map<String, String?> getUserCredentials() {
    return {
      'userEmail': _prefs.getString('userEmail'),
      'accessToken': _prefs.getString('accessToken'),
      'displayName': _prefs.getString('displayName'),
      'photoUrl': _prefs.getString('photoUrl'),
    };
  }

  Future<void> clearUserCredentials() async {
    await _prefs.remove('userEmail');
    await _prefs.remove('accessToken');
    await _prefs.remove('displayName');
    await _prefs.remove('photoUrl');
  }
}
