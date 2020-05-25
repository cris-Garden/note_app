
import 'package:shared_preferences/shared_preferences.dart';

class UserDefaults {
  static final UserDefaults _util = UserDefaults._internal();

  UserDefaults._internal();

  factory UserDefaults(){
    return _util;
  }

  void saveStringData(String key,String value) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  Future<String> getStringData(String key) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  void saveBoolData(String key,bool value) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  Future<bool> getBoolData(String key) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  void removeData(String key) async {

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

}