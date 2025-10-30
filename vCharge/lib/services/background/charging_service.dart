// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//       iosConfiguration: IosConfiguration(
//           autoStart: true, onForeground: onStart, onBackground: onBackground),
//       androidConfiguration: AndroidConfiguration(
//           onStart: onStart, isForegroundMode: true, autoStart: true)
//   );
//
//   await service.startService();
// }
//
// @pragma("vm:entry-point")
// Future<bool> onBackground(ServiceInstance service) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }
//
// @pragma("vm:entry-point")
// void onStart(ServiceInstance service) async{
//
//   if (service is AndroidServiceInstance) {
//     service.on("SetAsForeground").listen((event) {
//       service.setAsForegroundService();
//     });
//     service.on("SetAsBackground").listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on("onStop").listen((event) {
//     service..stopSelf();
//   });
//   Timer.periodic(Duration(seconds: 2), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         service.setForegroundNotificationInfo(
//             title: "vCharge",
//             content: "${DateTime.now()} Your vehicle is charging..."
//         );
//       }
//     }
//
//     print("background service running.........");
//     service.invoke("update");
//   });
// }
