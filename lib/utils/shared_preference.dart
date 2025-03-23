import 'dart:convert';
import 'package:hotel_booking/core/constants/app_common_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences prefs;

  SharedPref(this.prefs);

  String? get getUserName {
    return prefs.getString(SharedPrefKey.prefUserName);
  }

  String? get getToken {
    return prefs.getString(SharedPrefKey.prefToken);
  }

  bool? get getLoggedIn {
    return prefs.getBool(SharedPrefKey.prefLoggedIn);
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveModel<T>(String key, T value) async {
    String jsonString = jsonEncode(value);
    await prefs.setString(key, jsonString);
  }

  T? getModel<T>(String key) {
    String? jsonValue = prefs.getString(key);
    if (jsonValue != null) {
      return jsonDecode(jsonValue) as T;
    }
    return null;
  }

  void saveString(String key, String value) async {
    prefs.setString(key, value);
  }

  String getString(String key) {
    return prefs.getString(key) ?? "";
  }

  void saveBool(String key, bool value) async {
    prefs.setBool(key, value);
  }

  bool getBool(String key) {
    return prefs.getBool(key) ?? false;
  }

  // Example method to check if a value exists in SharedPreferences
  bool containsKey(String key) {
    return prefs.containsKey(key);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}
