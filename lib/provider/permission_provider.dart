import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionProvider extends ChangeNotifier {
  PermissionProvider(this._preferences);

  @visibleForTesting
  String systemAlertWindowGranted = "systemAlertWindowGranted";
  String ignoreBatteryOptimizationsGranted = "ignoreBatteryOptimizations";
  String storageGranted = "storageGranted";

  bool systemAlertWindowGrantedBool = false;
  bool storageGrantedBool = false;

  final SharedPreferences _preferences;

  bool isGrantedAll() {
    return _preferences.getBool(systemAlertWindowGranted) ?? false;
  }

  bool isIgnoreBatteryGranted() {
    return _preferences.getBool(ignoreBatteryOptimizationsGranted) ?? false;
  }

  bool isStorageGranted() {
    return _preferences.getBool(storageGranted) ?? false;
  }

  Future<bool> requestSystemAlertWindow() async {
    if (await Permission.systemAlertWindow.status != PermissionStatus.granted) {
      await Permission.systemAlertWindow.request();
    }

    if (await Permission.systemAlertWindow.status == PermissionStatus.granted) {
      await _preferences.setBool(systemAlertWindowGranted, true);
      systemAlertWindowGrantedBool = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> ignoreBatteryOptimizations() async {
    if (await Permission.ignoreBatteryOptimizations.status !=
        PermissionStatus.granted) {
      await Permission.ignoreBatteryOptimizations.request();
    }

    if (await Permission.ignoreBatteryOptimizations.status ==
        PermissionStatus.granted) {
      await _preferences.setBool(ignoreBatteryOptimizationsGranted, true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> storagePermission() async {
    if (await Permission.storage.status != PermissionStatus.granted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.status == PermissionStatus.granted) {
      await _preferences.setBool(storageGranted, true);
      storageGrantedBool = true;
      notifyListeners();
      return true;
    }
    return false;
  }
}
