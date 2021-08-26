import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_beauty/values/constants.dart';

class SharedPref{
  setGenderPref(String gender,String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(genderPref, gender);
    prefs.setString(genderImagePref, url);
  }
  Future<String> getGenderPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String gender = (prefs.getString(genderPref) ?? "");
    return gender;
  }
  Future<String> getGenderImagePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String image = (prefs.getString(genderImagePref) ?? "");
    return image;
  }

  setPopupPref(bool isPopupFirst) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(popupPref, isPopupFirst);
  }
  Future<bool> getPopupPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPopupfirstTime = (prefs.getBool(popupPref) ?? true);
    return isPopupfirstTime;
  }

}