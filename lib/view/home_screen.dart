// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_list_provider.dart';
import 'package:flutter_alarm_app/provider/switch_provider.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';
import 'package:flutter_alarm_app/view/SettingsScreen/wakeup_settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _createAlarm(
      BuildContext context, AlarmListProvider alarmListProvider) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 30),
    );
    if (time == null) return;

    final alarm = Alarm(
      id: alarmListProvider.getAvailableAlarmId(),
      hour: time.hour,
      minute: time.minute,
      enabled: true,
    );

    alarmListProvider.add(alarm);
    await AlarmScheduler.scheduleRepeatable(alarm);
  }

  void _handleCardTap(
    AlarmListProvider alarmList,
    Alarm alarm,
    BuildContext context,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: alarm.timeOfDay,
    );
    if (time == null) return;

    print(time);

    final newAlarm = alarm.copyWith(hour: time.hour, minute: time.minute);

    alarmList.replace(alarm, newAlarm);
    if (alarm.enabled) await AlarmScheduler.cancelRepeatable(alarm);
    if (newAlarm.enabled) await AlarmScheduler.scheduleRepeatable(newAlarm);
  }

  int timerValue = 15;
  @override
  Widget build(BuildContext context) {
    var switchProvider = Provider.of<SwitchProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Alarm App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const WakeupSettingsPage()));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: Provider.of<AlarmListProvider>(context).length == 1
          ? null
          : FloatingActionButton(
              onPressed: () {
                _createAlarm(context, context.read<AlarmListProvider>());
              },
              child: const Icon(Icons.add),
            ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Consumer<AlarmListProvider>(
                builder: (context, alarmList, child) => ListView.builder(
                  itemCount: alarmList.length,
                  itemBuilder: (context, index) {
                    final alarm = alarmList[index];
                    return _AlarmCard(
                      alarm: alarm,
                      onTapSwitch: (enabled) {
                        // _switchAlarm(alarmList, alarm, enabled);
                        switchProvider.switchAlarm(alarmList, alarm, enabled);
                        print("ALARM SWITCH $enabled");
                      },
                      onTapCard: () {
                        _handleCardTap(alarmList, alarm, context);
                      },
                    );
                  },
                ),
              ),
            ),
            Text(timerValue.toString()),
            TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    timerValue = prefs.getInt('intValue')!;
                  });
                  print(timerValue);
                },
                child: Text("get timer"))
          ],
        ),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  const _AlarmCard({
    Key? key,
    required this.alarm,
    required this.onTapSwitch,
    required this.onTapCard,
  }) : super(key: key);

  final Alarm alarm;
  final void Function(bool enabled) onTapSwitch;
  final VoidCallback onTapCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTapCard,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  alarm.timeOfDay.format(context),
                  style: theme.textTheme.headline6!.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(
                      alarm.enabled ? 1.0 : 0.4,
                    ),
                  ),
                ),
              ),
              Switch(
                value: alarm.enabled,
                onChanged: onTapSwitch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
