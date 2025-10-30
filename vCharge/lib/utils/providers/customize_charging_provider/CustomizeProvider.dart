import 'package:flutter/material.dart';

class CustomizeProvider with ChangeNotifier {
  int currentIndex = 0;
  int get itemIndex => currentIndex;

  void setIndex(index) {
    this.currentIndex = index;
    // print(currentIndex);
    notifyListeners();
  }

  int time = 0;
  int get timeLimit => time;

  void setTime(time) {
    this.time = time;
    notifyListeners();
  }

  int unit = 0;
  int get unitLimit => unit;

  void setUnit(unit) {
    this.unit = unit;
    notifyListeners();
  }

  double money = 0.0;
  double get moneyLimit => money;

  void setMoney(money) {
    this.money = money;
    notifyListeners();
  }
}
