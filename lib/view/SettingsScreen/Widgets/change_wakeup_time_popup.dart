import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_list_provider.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';

class ChangeWakeUpTimePopUp extends StatefulWidget {
  final Alarm alarm;
  final AlarmListProvider alarmList;
  const ChangeWakeUpTimePopUp({
    Key? key,
    required this.alarm,
    required this.alarmList,
  }) : super(key: key);

  @override
  State<ChangeWakeUpTimePopUp> createState() => _ChangeWakeUpTimePopUpState();
}

class _ChangeWakeUpTimePopUpState extends State<ChangeWakeUpTimePopUp> {
  void _changeWakeUpCallTime(
    AlarmListProvider alarmList,
    Alarm alarm,
    int? hour,
    int? minute,
  ) async {
    final newAlarm = alarm.copyWith(hour: hour, minute: minute);

    alarmList.replace(alarm, newAlarm);
    if (alarm.enabled) await AlarmScheduler.cancelRepeatable(alarm);
    if (newAlarm.enabled) await AlarmScheduler.scheduleRepeatable(newAlarm);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        // height: 200,
        width: 300,
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          crossAxisCount: 3,
          children: <Widget>[
            TextButton(
              onPressed: widget.alarm.hour == 1 && widget.alarm.minute != 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 01, 00);
                      Navigator.pop(context);
                    },
              child: const Text('01:00 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 1 && widget.alarm.minute == 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 01, 30);
                      Navigator.pop(context);
                    },
              child: const Text('01:30 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 2 && widget.alarm.minute != 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 02, 00);
                      Navigator.pop(context);
                    },
              child: const Text('02:00 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 2 && widget.alarm.minute == 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 02, 30);
                      Navigator.pop(context);
                    },
              child: const Text('02:30 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 3 && widget.alarm.minute != 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 03, 00);
                      Navigator.pop(context);
                    },
              child: const Text('03:00 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 3 && widget.alarm.minute == 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 03, 30);
                      Navigator.pop(context);
                    },
              child: const Text('03:30 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 4 && widget.alarm.minute != 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 04, 00);
                      Navigator.pop(context);
                    },
              child: const Text('04:00 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 4 && widget.alarm.minute == 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 04, 30);
                      Navigator.pop(context);
                    },
              child: const Text('04:30 AM'),
            ),
            TextButton(
              onPressed: widget.alarm.hour == 5 && widget.alarm.minute != 30
                  ? null
                  : () {
                      _changeWakeUpCallTime(
                          widget.alarmList, widget.alarm, 05, 00);
                      Navigator.pop(context);
                    },
              child: const Text('05:00 AM'),
            ),
          ],
        ),
      ),
    );
  }
}
