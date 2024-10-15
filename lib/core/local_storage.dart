import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
   static late SharedPreferences pref;

  static initialize()async{
    pref =await SharedPreferences.getInstance();
  }
}