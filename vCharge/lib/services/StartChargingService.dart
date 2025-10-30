// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/services/urls.dart';
import '../view/startChargingScreen/startChargingScreen.dart';

class StartChargingService {
  late BuildContext context;
  StartChargingService(BuildContext context) {
    this.context = context;
  }

  bool checkRegx(String trnid) {
    RegExp regx = RegExp(r'^TRN\d{17}$');
    return regx.hasMatch(trnid);
  }

  startChargingApiCall(
      String userId,
      String idTag,
      String connectorNumber,
      String chargerSerialNumber,
      int minutes,
      int unit,
      double money,
      String modeOfCharging) async {
    try {
      final requestBody = {
        "userId": userId,
        "idTag": idTag,
        "connectorNumber": connectorNumber,
        "chargerSerialNumber": chargerSerialNumber,
        "amount": money * 100,
        "minutes": minutes,
        "unit": unit * 1000,
        "modeOfCharging": modeOfCharging
      };

      final requestBodyJson = json.encode(requestBody);

      final apiUrl =
          Uri.parse('${Urls().occpUrl}/ocppServer/remoteStartTransaction');

      final response = await http.post(apiUrl,
          headers: {'Content-Type': 'application/json'}, body: requestBodyJson);

      if (response.statusCode == 200) {
        var status = jsonDecode(response.body);
        //print("response is this  : ${response.body} ");

        if (checkRegx(status['status'])) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartChargingScreen(
                        TRNID: status['status'],
                      )));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                // print("this is not working status is  : ${status['status']}");
                return AlertDialog(
                  content: Text('${status['status']}'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                );
              });
        }
      } else {
        Navigator.pop(context);
        //Components().showSnackbar(Components().something_want_wrong, context);
      }
    } catch (e) {
      Navigator.pop(context);
      //Components().showSnackbar(Components().something_want_wrong, context);
    }
  }
}
