import 'package:flutter/material.dart';

///! currently not using

class ResponseCounter extends ChangeNotifier {
  int counter = 0;

  getCounter() => counter;
  setCounter(int counter) {
    counter = counter;
  }

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void clearCounter() {
    counter = 0;
    notifyListeners();
  }
}
