// ignore_for_file: avoid_print

import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_state.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';
import 'package:flutter_alarm_app/view/alarm_second_screen.dart';
import 'package:flutter_audio_output/flutter_audio_output.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key, required this.alarm}) : super(key: key);

  final Alarm alarm;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> with WidgetsBindingObserver {
  final logger = Logger(
      printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: true,
  ));
  late AudioPlayer _audioPlayer;
  final audioPlayer = AudioPlayer();

  late Timer timer;

  int _responseCounter = 0;
  void loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseCounter = (prefs.getInt('counter') ?? 0);
    });
  }

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _responseCounter = ((prefs.getInt('counter') ?? 0) + 1);
      prefs.setInt('counter', _responseCounter);
    });
  }

  void _clearCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // prefs.remove("counter");
      prefs.setInt('counter', 0);
    });
  }

  void _getCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      int? value = prefs.getInt('counter');
      logger.e(value);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    logger.w("TTTTTTTTTTTTTTTTMMMMMMMMMMMMMMMMMM  $_responseCounter");
    // logger.e(Provider.of<ResponseCounter>(context, listen: false).counter);
    loadCounter();
    _getCounter();

    // if (timerCounter > 2) {
    //   _dismissAlarm();
    // } else {
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      timer = t;
      _fiveMinutesAlarm();
      SystemNavigator.pop();
      logger.w("Music Playing Again after 5 minutes");
      logger.w("Timer Tic ${timer.tick}");
      _clearCounter();
      _getCounter();
    });
    // }

    // ------------------ MUSIC PLAYER --------------- //
    _audioPlayer = AudioPlayer();
    _audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///assets/Sunflower.mp3"),
      ),
    )
        .catchError((error) {
      logger.e("An error occured $error");
    });
    _audioPlayer.play();
    FlutterAudioOutput.changeToSpeaker();
    _getCounter();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // _dismissAlarm();
        _fifteenMinShot();
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
    final firedAlarmWeekday = callbackAlarmId % 7;
    final nextAlarmTime =
        widget.alarm.timeOfDay.toComingDateTimeAt(firedAlarmWeekday);
    await AlarmScheduler.rescheduleFiveMinutes(callbackAlarmId, nextAlarmTime);
    timer.cancel();
    _clearCounter();
    alarmState.dismiss();
    _audioPlayer.stop();
    Wakelock.disable();
  }

  void _dismissAlarm() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;
    await AndroidAlarmManager.cancel(callbackAlarmId);
    timer.cancel();
    alarmState.dismiss();
    _audioPlayer.stop();
    Wakelock.disable();
  }

  void _fifteenMinShot() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;

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
                          if (_responseCounter >= 2) {
                            _dismissAlarm();
                            SystemNavigator.pop();
                            logger.w('2ND TIME COUNTER');
                            _clearCounter();
                          } else {
                            _fifteenMinShot();
                            SystemNavigator.pop();
                            timer.cancel();
                            timer.cancel;
                            logger.w('15 MIN. CONDITION CHECK');
                            _incrementCounter();
                            logger.w(_responseCounter);
                          }
                          // setState(() {
                          //   // responseCounter + 1;

                          // });
                          // counter.incrementCounter();
                          logger.e(_responseCounter);
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
                          // //! NAVIGATE TO SECOND SCREEN
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool? isConfirmOn = prefs.getBool('isConfirmOn');

                          if (isConfirmOn == true) {
                            logger.w("CONFIRMATION CHECK IS TRUE");
                            if (_responseCounter >= 2) {
                              _dismissAlarm();
                              _clearCounter();
                              logger.w('2nd TIME Accecpted COUNTER');
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return AlarmSecondScreen(
                                  alarm: widget.alarm,
                                );
                              }), (Route route) => false);
                            } else {
                              _fifteenMinShot();
                              timer.cancel();
                              timer.cancel;
                              logger.w('15 MIN. Accecpted  CONDITION CHECK');
                              _incrementCounter();
                              logger.w(_responseCounter);
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return AlarmSecondScreen(
                                  alarm: widget.alarm,
                                );
                              }), (Route route) => false);
                            }
                          } else {
                            logger.w("APP CLOSED");
                            _dismissAlarm();
                            _clearCounter();
                            SystemNavigator.pop();
                          }
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
