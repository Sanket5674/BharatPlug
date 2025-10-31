import 'package:flutter/material.dart';

// this is the provider function for implementing the dark theme mode
class DarkThemeProvider with ChangeNotifier {

  var currentThemeMode = ThemeMode.light; 
  ThemeMode get themeMode => currentThemeMode;

  void setTheme(themeMode){
    currentThemeMode = themeMode;
    notifyListeners();
  }
}