import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  dynamic getFromDisk(String key) {
    try {
      dynamic value = _preferences.get(key);
      return value;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void saveStringToDisk(String key, String content) {
    try {
      _preferences.setString(key, content);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void saveBoolToDisk(String key, bool value) {
    try {
      _preferences.setBool(key, value);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void deleteFromDisk(String key) {
    try {
      _preferences.remove(key);
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
