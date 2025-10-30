import 'dart:ui';

import 'package:flutter/material.dart';

class Components {
  static Color fontColorBlack = Color(0xff000000);
  static Color green = Color(0xff007a34);
  static Color mediumGreen = Color(0xff009440);
  static Color lightGreen = Color(0xff00bd52);
  static Color red = Color(0xffee0d0d);
  static Color white = Color(0xffffffff);

  String something_went_wrong = "";

  void showSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      content: Text(
        message,
        style: TextStyle(color: Colors.black),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
