import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vcharge/view/homeScreen/homeScreen.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings("logo");

  void initializeNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendNotification(BuildContext context, String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            playSound: true);

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
    // _flutterLocalNotificationsPlugin.periodicallyShow(1, title, body, RepeatInterval.everyMinute, notificationDetails);
    //print("working ===========================================================");
  }

  void stopNotification() async {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
