import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../services/notificationService.dart';
import '../../../services/urls.dart';

class StopChargingAlertPopUp extends StatelessWidget {
  final String TRNID;

  const StopChargingAlertPopUp({super.key, required this.TRNID});
  Future<bool> stopCharging(BuildContext context) async {
    try {
      //print("TRNID : ${TRNID}");
      final storage = FlutterSecureStorage();
      final res = await http.get(Uri.parse(
          "${Urls().occpUrl}/ocppServer/remoteStopTransaction?chargerSerialNo=VPEL&transactionId=${TRNID}"));
      if (res.statusCode == 200) {
        await storage.delete(key: 'TRNID');
        //print("res : ${data.toString()}");
        NotificationService notificationService = NotificationService();
        notificationService.stopNotification();
        // final service = FlutterBackgroundService();
        // bool isRunning = await service.isRunning();
        // if(isRunning){
        //   service.invoke("onStop");
        // }
        return true;
      } else {
        //print("res : ${data.toString()}");
        return false;
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    void showSnackbar(String message) {
      final snackBar = SnackBar(
        content: Text(message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return AlertDialog(
      title: const Text(
        'ALERT...!!!',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to stop charging'),
      actions: [
        TextButton(
            onPressed: () async {
              // var response = GetMethod.getRequestMod('http://192.168.0.44:8080/remoteStopTransaction');
              // //print(response);

              if (await stopCharging(context)) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showSnackbar("stop charging");
              } else {
                showSnackbar("Failed to stop");
              }
            },
            child: const Text('Yes')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'))
      ],
    );
  }
}
