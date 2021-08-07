import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_beauty/values/constants.dart';

class SharedPref{
  setGenderPref(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(genderPref, gender);
  }
  Future<String> getGenderPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = (prefs.getString(genderPref) ?? "");
    return gender;
  }
}