
import 'package:shared_preferences/shared_preferences.dart';

/// Save User ///
class SaveUser{
  static Future<bool> setUser(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("user", token);
  }
  static Future<String> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("user"));
    return prefs.getString("user") ?? '';
  }
}
