import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app/models/user_tbl.dart';

class SessionManager {
  
  static SharedPreferences _sharedPrefs;
  
  static void initialize(SharedPreferences sharedPreferences) {
    _sharedPrefs = sharedPreferences;
  }
  
  static bool isLoggedIn() {
    return _sharedPrefs.getBool('logged_in') ?? false;
  }
  
  static void hasLoggedIn() {
    _sharedPrefs.setBool('logged_in', true);
  }
  
  static void hasLoggedOut() {
    _sharedPrefs.setBool('logged_in', false);
  }

  static String getToken() {
    return _sharedPrefs.getString('access_token') ?? "";
  }
  
  static void setToken(String token) {
    _sharedPrefs.setString('access_token', token);
  }
   
  static void setAvatarPath(String email, String path) {
    _sharedPrefs.setString('${email}_avatar', path);
  }
  
  static String getAvatarPath(String email) {
    return _sharedPrefs.getString('${email}_avatar') ?? '';
  }

  static void setGender(Gender gender) {
    _sharedPrefs.setString('gender', gender == Gender.MALE ? 'male' : 'female');
  }

  static Gender getGender()  {
    return _sharedPrefs.getString('gender') == 'male' ? Gender.MALE : Gender.FEMALE;
  }
   
  
  static String getUserID() {
    return _sharedPrefs.getString('patient_id') ?? '';
  }
  
  static void setUserID(String id) {
    _sharedPrefs.setString('patient_id', id);
  }
  
  static String getEmail() {
    return _sharedPrefs.getString('email') ?? '';
  }
  
  static void setEmail(String email) {
    _sharedPrefs.setString('email', email);
  }
}