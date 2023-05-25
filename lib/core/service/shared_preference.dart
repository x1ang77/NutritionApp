import 'package:nutrition_app/core/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences? sharedPref;

  static Future<SharedPreferences> createPref() async {
    if(sharedPref != null) {
      return sharedPref!;
    }
    sharedPref = await SharedPreferences.getInstance();
    return sharedPref!;
  }

  static Future<bool> isLoggedIn() async {
    final sharedPref = await createPref();
    return sharedPref.getBool(Constants.isLoggedIn) ?? false;
  }

  static Future<void> setIsLoggedIn(bool status) async {
    final sharedPref = await createPref();
    sharedPref.setBool(Constants.isLoggedIn, status);
  }
}