import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> write({key, required bool value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    return;
  }

  Future<bool?> read({key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<void> deleteAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return;
  }

  Future<void> delete({key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    return;
  }
}
