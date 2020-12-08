import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isArabic = prefs.getString('lang');
    return isArabic;
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var datId = prefs.get("token");
    return datId;
  }
}
