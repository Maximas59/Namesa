import 'package:shared_preferences/shared_preferences.dart';

class MyCache {
  static SharedPreferences? preferences;

  static Future<void> initCache() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void setString({required String key, required String value}) {
    preferences!.setString(key, value);
  }

  static String getString({required String key}) {
    return preferences!.getString(key) ?? " ";
  }

  static Future<bool> clear() async {
    return await preferences!.clear();
  }
}
