import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  final SharedPreferences mPreferences;

  PreferenceHelper(
    this.mPreferences,
  );

  static PreferenceHelper of({required SharedPreferences preferences}) {
    return PreferenceHelper(preferences);
  }

  bool isAdded({required String key}) {
    return mPreferences.containsKey(key);
  }

  bool isNotAdded({required String key}) {
    return !mPreferences.containsKey(key);
  }

  Object? getItem({required String key}) {
    return mPreferences.get(key);
  }

  Set<String> getKeys() {
    return mPreferences.getKeys();
  }

  bool getBoolean({required String key}) {
    final value = mPreferences.getBool(key);
    return value ?? false;
  }

  double getDouble({required String key}) {
    final value = mPreferences.getDouble(key);
    return value ?? 0.0;
  }

  int getInt({required String key}) {
    final value = mPreferences.getInt(key);
    return value ?? 0;
  }

  String? getString({required String key}) {
    final value = mPreferences.getString(key);
    return value;
  }

  List<String>? getStrings({required String key}) {
    return mPreferences.getStringList(key);
  }

  Future<bool> setBoolean({required String key, required bool value}) {
    return mPreferences.setBool(key, value);
  }

  Future<bool> setDouble({required String key, required double value}) {
    return mPreferences.setDouble(key, value);
  }

  Future<bool> setInt({required String key, required int value}) {
    return mPreferences.setInt(key, value);
  }

  Future<bool> setString({required String key, required String value}) {
    return mPreferences.setString(key, value);
  }

  Future<bool> setStrings({required String key, required List<String> values}) {
    return mPreferences.setStringList(key, values);
  }

  Future<bool> removeItem({required String key}) {
    return mPreferences.remove(key);
  }

  Future<bool> clearItems() {
    return mPreferences.clear();
  }

  Future<void> reloadItems() {
    return mPreferences.reload();
  }
}
