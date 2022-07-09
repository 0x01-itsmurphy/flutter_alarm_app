// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_app/model/alarm.dart';
import 'package:flutter_alarm_app/provider/alarm_state.dart';
import 'package:flutter_alarm_app/service/alarm_scheduler.dart';
import 'package:flutter_audio_output/flutter_audio_output.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class AlarmSecondScreen extends StatefulWidget {
  final Alarm alarm;
  // final VoidCallback onTap;
  // final AudioPlayer audioPlayer;
  const AlarmSecondScreen({Key? key, required this.alarm}) : super(key: key);

  @override
  State<AlarmSecondScreen> createState() => _AlarmSecondScreenState();
}

class _AlarmSecondScreenState extends State<AlarmSecondScreen>
    with WidgetsBindingObserver {
  late AudioPlayer _audioPlayer;

  late AudioInput _currentInput = const AudioInput("unknow", 0);
  late List<AudioInput> _availableInputs = [];
  bool isSpeaker = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _audioPlayer = AudioPlayer();
    _audioPlayer
        .setAudioSource(
      AudioSource.uri(
        Uri.parse('asset:///assets/music2.mp3'),
      ),
    )
        .catchError((error) {
      // catch load errors: 404, invalid url ...
      print("An error occured $error");
    });
    _audioPlayer.play();
    FlutterAudioOutput.changeToReceiver();
    init();
    super.initState();
  }

  Future<void> init() async {
    FlutterAudioOutput.setListener(() async {
      print("-----changed-------");

      await _getInput();
      setState(() {});
    });

    await _getInput();
    if (!mounted) return;
    setState(() {});
  }

  _getInput() async {
    _currentInput = await FlutterAudioOutput.getCurrentOutput();
    print("current input :$_currentInput");

    _availableInputs = await FlutterAudioOutput.getAvailableInputs();
    print("available inputs  $_availableInputs");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        _dismissAlarm();
        break;

      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioPlayer.dispose();
    super.dispose();
  }

  void _dismissAlarm() async {
    final alarmState = context.read<AlarmState>();
    final callbackAlarmId = alarmState.callbackAlarmId!;

    final firedAlarmWeekday = callbackAlarmId % 7;
    final nextAlarmTime =
        widget.alarm.timeOfDay.toComingDateTimeAt(firedAlarmWeekday);

    await AlarmScheduler.reschedule(callbackAlarmId, nextAlarmTime);

    alarmState.dismiss();
    _audioPlayer.stop();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enabled;
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
          color: Colors.green[900],
          child: Column(
            children: [
              //Space
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.verified_user,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
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
                "00:00",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              //Space
              const SizedBox(
                height: 15,
              ),
              //
              //Img
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage("assets/images/img2.jpg"),
                    // ),
                  ),
                  child: Lottie.asset('assets/lottiee/happy-girlpeaceful.json'),
                ),
              ),

              //
              Column(
                children: [
                  //Space
                  const SizedBox(
                    height: 5,
                  ),
                  const Icon(
                    Icons.arrow_upward,
                    size: 22,
                    color: Colors.white,
                  ),

                  //Space
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await _getInput();
                          if (_currentInput.port == AudioPort.speaker) {
                            isSpeaker =
                                await FlutterAudioOutput.changeToReceiver();
                            setState(() {
                              isSpeaker = false;
                            });
                            print("change to Receiver :$isSpeaker");
                          } else {
                            isSpeaker =
                                await FlutterAudioOutput.changeToSpeaker();
                            setState(() {
                              isSpeaker = true;
                            });
                            print("change to Speaker :$isSpeaker");
                          }
                        },
                        icon: isSpeaker == false
                            ? const Icon(
                                Icons.volume_off,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              ),
                      ),
                      const Icon(
                        Icons.mic,
                        size: 22,
                        color: Colors.white,
                      ),
                      const Icon(
                        Icons.video_call,
                        color: Colors.white,
                      ),
                      //
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              _dismissAlarm();
                              SystemNavigator.pop();
                            },
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  //Space
                  const SizedBox(
                    height: 20,
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
