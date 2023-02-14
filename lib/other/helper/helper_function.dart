import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_communication/core/utils/helpers/preference_helper.dart';
import 'package:flutter_communication/feature/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper {
  final PreferenceHelper helper;

  UserHelper({
    required this.helper,
  });

  static String userKey = "uid";

  Future<bool> saveUser(UserEntity user) async {
    try {
      final json = jsonEncode(user.map);
      print("Data : $json");
      return helper.setString(key: userKey, value: json);
    } catch (_) {
      print("Error : $_");
      return false;
    }
  }

  Future<bool> removeUser() async {
    await FirebaseAuth.instance.signOut();
    try {
      return helper.removeItem(key: userKey);
    } catch (_) {
      print("Error : $_");
      return false;
    }
  }

  bool get isLoggedIn => user != null;

  UserEntity? get user {
    try {
      final source = helper.getString(key: userKey);
      if (source != null) {
        final data = jsonDecode(source);
        print("Local User : $data");
        return data is Map<String, dynamic> ? UserEntity.from(data) : null;
      } else {
        return null;
      }
    } catch (_) {
      print("Local User : $_");
      return null;
    }
  }
}

class HelperFunctions {
  //keys
  static String userLoggedInKey = "logged_in";
  static String userNameKey = "user_name";
  static String userEmailKey = "user_email";

  // saving the data to SF

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  // getting the data from SF

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }
}
