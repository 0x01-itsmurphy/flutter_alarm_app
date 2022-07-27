// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeConfirmCallTime extends StatefulWidget {
  const ChangeConfirmCallTime({Key? key}) : super(key: key);

  @override
  State<ChangeConfirmCallTime> createState() => _ChangeConfirmCallTimeState();
}

class _ChangeConfirmCallTimeState extends State<ChangeConfirmCallTime> {

  addTimerValueToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('intValue', timerValue);
  }

  getTimerValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timerValue = prefs.getInt('intValue')!;
    });
  }

  @override
  void initState() {
    getTimerValuesSF();
    super.initState();
  }

  int timerValue = 15;

  @override
  Widget build(BuildContext context) {
    print(timerValue);
    return AlertDialog(
      content: Container(
        width: double.infinity,
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: timerValue == 15
                    ? null
                    : () async {
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // prefs.setInt('intValue', 15);
                        timerValue = 15;
                        addTimerValueToSF();
                        // addIntToSF(15);
                        Navigator.pop(context);
                      },
                child: const Text("15 minutes"),
              ),
              TextButton(
                onPressed: timerValue == 20
                    ? null
                    : () async {
                        // addIntToSF(20);
                        addTimerValueToSF();
                        timerValue = 20;
                        Navigator.pop(context);
                      },
                child: const Text("20 minutes"),
              ),
              TextButton(
                onPressed: timerValue == 25
                    ? null
                    : () async {
                        addTimerValueToSF();
                        timerValue = 25;
                        Navigator.pop(context);
                      },
                child: const Text("25 minutes"),
              ),
              TextButton(
                onPressed: timerValue == 30
                    ? null
                    : () async {
                        timerValue = 30;
                        addTimerValueToSF();
                        Navigator.pop(context);
                      },
                child: const Text("30 minutes"),
              ),
            ],
          );
        }),
      ),
    );
  }
}
