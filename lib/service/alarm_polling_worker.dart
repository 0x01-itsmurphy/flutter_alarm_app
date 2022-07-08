import 'package:flutter/cupertino.dart';
import 'package:flutter_alarm_app/service/alarm_flag_manager.dart';
import 'package:flutter_alarm_app/provider/alarm_state.dart';

class AlarmPollingWorker {
  static final AlarmPollingWorker _instance = AlarmPollingWorker._();

  factory AlarmPollingWorker() {
    return _instance;
  }

  AlarmPollingWorker._();

  bool _running = false;

  /// Start searching for alarm flags.
  void createPollingWorker(AlarmState alarmState) async {
    if (_running) return;

    debugPrint('Starts polling worker');
    _running = true;
    final int? callbackAlarmId = await _poller(10);
    _running = false;

    if (callbackAlarmId != null) {
      if (!alarmState.isFired) {
        alarmState.fire(callbackAlarmId);
      }
      await AlarmFlagManager().clear();
    }

    debugPrint('alarm polling --$callbackAlarmId');
  }

  /// If an alarm flag is found, the Id of the corresponding alarm is returned, and if there is no flag, `null' is returned.
  Future<int?> _poller(int iterations) async {
    int? alarmId;
    int iterator = 0;

    await Future.doWhile(() async {
      alarmId = await AlarmFlagManager().getFiredId();
      if (alarmId != null || iterator++ >= iterations) return false;
      await Future.delayed(const Duration(milliseconds: 25));
      return true;
    });
    return alarmId;
  }
}
