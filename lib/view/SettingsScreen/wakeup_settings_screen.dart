// ignore_for_file: avoid_print

import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_list_provider.dart';
import 'package:flutter_alarm_app/provider/switch_provider.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';
import 'package:flutter_alarm_app/view/SettingsScreen/Widgets/change_wakeup_time_popup.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<bool> hasValues() async {
  final prefs = await SharedPreferences.getInstance();
  bool checkValue = prefs.containsKey('isWakeupOn');
  return checkValue;
}

class WakeupSettingsPage extends StatefulWidget {
  static String id = 'settings';
  const WakeupSettingsPage({Key? key}) : super(key: key);
  @override
  State<WakeupSettingsPage> createState() => _WakeupSettingsPageState();
}

class _WakeupSettingsPageState extends State<WakeupSettingsPage> {
  late bool _isWakeupOn = false;
  late bool _isWakeUpForeverOn = false;
  late bool _isConfirmOn = false;

  Future<void> getValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isWakeupOn = prefs.getBool("isWakeupOn") ?? false;
      _isWakeUpForeverOn = prefs.getBool("isBoldOn") ?? false;
      _isConfirmOn = prefs.getBool("isConfirmOn") ?? true;
    });
    // return [isVibrationOn, isBoldOn, isNightModeOn];
  }

  Future<void> setValues() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isWakeupOn", _isWakeupOn);
    await prefs.setBool("isBoldOn", _isWakeUpForeverOn);
    await prefs.setBool("isNightModeOn", _isConfirmOn);
  }

  Future<void> hasValues() async {
    final prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey('isWakeupOn');
    setState(() {
      _isWakeupOn = checkValue;
      _isWakeUpForeverOn = checkValue;
      _isConfirmOn = checkValue;
    });
  }

  // Alarm alarm;

  @override
  void initState() {
    // print("${alarm!.enabled}");
    getValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var switchProvider = Provider.of<SwitchProvider>(context, listen: false);

    return Consumer<AlarmListProvider>(
      builder: (context, alarmList, child) {
        final alarm = alarmList[0];
        // var alarm;

        // for (var i = 0; i < alarmList.length; i++) {
        //   alarm = alarmList[i];
        // }

        print(alarm.enabled);
        print(alarmList.length);
        print("${alarm.hour} : ${alarm.minute}");
        
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.teal,
            title: const Text(" Wakeup Call Settings"),
          ),
          body: ListView(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 10.0),
                child: Text(
                  'Wakeup Call',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                title: const Text(
                  "Wakeup Call Today",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("No Wakeup Call for today",
                    style: TextStyle(fontSize: 12.0)),
                value: _isWakeupOn,
                onChanged: (bool value) {
                  setState(() {
                    _isWakeupOn = value;
                    setValues();
                  });
                },
              ),
              ListTile(
                title: const Text(
                  "Change Wakeup Call Time",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("Change Amritvela Wakeup Call Time",
                    style: TextStyle(fontSize: 12.0)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      return ChangeWakeUpTimePopUp(
                        alarm: alarm,
                        alarmList: alarmList,
                      );
                    },
                  );
                },
              ),
              SwitchListTile(
                title: const Text(
                  "Stop Wakeup Call Forever",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  "No Amritvela Time Wakeup Call",
                  style: TextStyle(fontSize: 12.0),
                ),
                value: alarm.enabled,
                onChanged: (bool value) {
                  setState(() {
                    _isWakeUpForeverOn = value;
                    setValues();
                    // TODO 2 Insert A Ternary Operator Here

                    switchProvider.switchAlarm(
                        alarmList, alarm, value); //! DO-NOT Remove
                  });
                },
              ),
              Container(
                color: Colors.black54,
                height: 1,
                width: double.infinity,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 15.0),
                child: Text(
                  'Confirmation Call After Wakeup Call',
                  style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5.0),
              ),
              SwitchListTile(
                title: const Text(
                  "Confirmation Call Required ?",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                    "Enable or Disable Confirmation Call after Wakeup Call",
                    style: TextStyle(fontSize: 12.0)),
                value: _isConfirmOn,
                onChanged: (bool value) {
                  setState(() {
                    _isConfirmOn = value;
                    setValues();
                    // TODO 3 Insert A Ternary Operator Here
                  });
                },
              ),
              ListTile(
                title: const Text(
                  "Confirmation Call held after",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                subtitle: const Text("Change Confirmation Call Time after call",
                    style: TextStyle(fontSize: 12.0)),
                onTap: () {
                  // RadioSettingsTile
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
