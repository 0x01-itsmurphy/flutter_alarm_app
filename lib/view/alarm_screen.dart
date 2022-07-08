// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_state.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';
import 'package:flutter_alarm_app/view/AlarmScreen/first_call_screen.dart';
import 'package:flutter_alarm_app/view/alarm_second_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'package:flutter_audio_manager/flutter_audio_manager.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key, required this.alarm}) : super(key: key);

  final Alarm alarm;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;
  final audioPlayer = AudioPlayer();

  late Timer timer;
  int timerCounter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("TTTTTTTTTTTTTTTTMMMMMMMMMMMMMMMMMM  $timerCounter");

    if (timerCounter > 2) {
      _dismissAlarm();
    } else {
      timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        timer = t;
        _fiveMinutesAlarm();
        SystemNavigator.pop();
        debugPrint("Music Playing Again after 5 minutes");
        debugPrint("Timer Tic ${timer.tick}");
      });
    }

    // ------------------ MUSIC PLAYER --------------- //
    _audioPlayer = AudioPlayer();
    _audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///assets/Sunflower.mp3"),
      ),
    )
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      print("An error occured $error");
    });
    _audioPlayer.play();
    // FlutterAudioManager.changeToReceiver();
    FlutterAudioManager.changeToSpeaker();
  }

  void playAfterDuration() {
    _audioPlayer = AudioPlayer();

    _audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///assets/Sunflower.mp3"),
      ),
    )
        .catchError((error) {
      print("An error occured $error");
    });
    _audioPlayer.play();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _dismissAlarm();
        _fiveMinutesAlarm();
        break;

      case AppLifecycleState.detached:
        _fiveMinutesAlarm();
        break;

      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    _audioPlayer.dispose();
    timer.cancel();
    super.dispose();
  }

  void _fiveMinutesAlarm() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;
    // The alarm callback ID is added by the 'AlarmScheduler' as equal to the number of days (0), months (1), Tuesdays (2), ... and Saturdays (6).
    // Therefore, the quotient divided by 7 represents the day of the week.
    final firedAlarmWeekday = callbackAlarmId % 7;
    final nextAlarmTime =
        widget.alarm.timeOfDay.toComingDateTimeAt(firedAlarmWeekday);

    // await AlarmScheduler.reschedule(callbackAlarmId, nextAlarmTime);
    await AlarmScheduler.rescheduleFiveMinutes(callbackAlarmId, nextAlarmTime);
    timer.cancel();
    alarmState.dismiss();
    _audioPlayer.stop();
    Wakelock.disable();
  }

  void _dismissAlarm() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;
    // // The alarm callback ID is added by the 'AlarmScheduler' as equal to the number of days (0), months (1), Tuesdays (2), ... and Saturdays (6).
    // // Therefore, the quotient divided by 7 represents the day of the week.
    final firedAlarmWeekday = callbackAlarmId % 7;
    final nextAlarmTime =
        widget.alarm.timeOfDay.toComingDateTimeAt(firedAlarmWeekday);

    await AlarmScheduler.reschedule(callbackAlarmId, nextAlarmTime);
    timer.cancel();
    alarmState.dismiss();
    _audioPlayer.stop();
    Wakelock.disable();
  }

  bool isAlarmScreen = true;

  @override
  Widget build(BuildContext context) {
    Wakelock.enable;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The System Back Button is Deactivated'),
          ),
        );
        return false;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xff212f3c),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                children: [
                  //Space
                  const SizedBox(
                    height: 50,
                  ),
                  //Img
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // image: DecorationImage(
                      //   fit: BoxFit.cover,
                      //   image: AssetImage("assets/images/img1.png"),
                      // ),
                    ),
                    child: Lottie.asset('assets/lottiee/peace-and-love.json'),
                  ),
                  //Space
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Amritvela Gurbani",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  //Space
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Wakeup Voice Call",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              //
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //* IF CALL REJECTED
                      InkWell(
                        onTap: () {
                          //! EXIT FROM APP
                          SystemNavigator.pop();
                          timer.cancel();
                          timer.cancel;
                          timerCounter + 1;
                          _dismissAlarm();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.call_end,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      //* IF CALL ACCEPTED
                      InkWell(
                        onTap: () async {
                          //! NAVIGATE TO SECOND SCREEN
                          timer.cancel();
                          timer.cancel;
                          print(timer);
                          print(timer.isActive);
                          print(timer.tick);
                          setState(() {
                            timerCounter + 1;
                          });
                          // _dismissAlarm();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return AlarmSecondScreen(
                              alarm: widget.alarm,
                            );
                          }), (Route route) => false);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: const Center(
                            child: Icon(
                              Icons.call,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Space
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "swipe up to accept",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  //Space
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
