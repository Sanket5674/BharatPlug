import 'package:flutter/material.dart';

class AvaliblityColor {
  //this function takes a parameter string as availiblityStatus, and returns a color based on availablity
  static MaterialColor getAvailablityColor(String availiblityStatus) {
    if (availiblityStatus.toLowerCase().replaceAll(' ', '') == 'available') {
      return Colors.green;
    } else if (availiblityStatus.toLowerCase().replaceAll(' ', '') ==
        'unavailable') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }
}
