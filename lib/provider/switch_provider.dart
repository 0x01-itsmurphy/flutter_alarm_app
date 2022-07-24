import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_list_provider.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';

class SwitchProvider extends ChangeNotifier {
  bool isEnable = false;

  void switchAlarm(
    AlarmListProvider alarmListProvider,
    Alarm alarm,
    bool enabled,
  ) async {
    isEnable = enabled;
    isEnable = alarm.enabled;
    notifyListeners();
    final newAlarm = alarm.copyWith(enabled: enabled);
    alarmListProvider.replace(
      alarm,
      newAlarm,
    );
    notifyListeners();
    if (enabled) {
      await AlarmScheduler.scheduleRepeatable(newAlarm);
      notifyListeners();
    } else {
      await AlarmScheduler.cancelRepeatable(newAlarm);
      notifyListeners();
    }
    notifyListeners();
  }
}
