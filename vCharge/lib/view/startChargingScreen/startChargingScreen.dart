import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcharge/services/notificationService.dart';
import 'package:vcharge/view/components.dart';
import '../../services/urls.dart';
import 'widgets/stopChargingAlertPopup.dart';

class StartChargingScreen extends StatefulWidget {
  final String TRNID;
  StartChargingScreen({super.key, required this.TRNID});

  @override
  State<StatefulWidget> createState() => StartChargingScreenState();
}

class StartChargingScreenState extends State<StartChargingScreen> {
  final storage = FlutterSecureStorage();
  String chargerName = "";
  String transactionTime = "00:00:00";
  int percent = 50;
  double unitUsed = 0.00;
  double transactionAmount = 0.0;

  Future getChargingData() async {
    String url =
        "${Urls().transactionUrl}/manageTransaction/getTransactionById?transactionId=${widget.TRNID}";
    //print("this is URL : $url");
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        //print(response.body);
        var data = jsonDecode(response.body);
        setState(() {
          chargerName = data["chargerName"] ?? "";
          transactionAmount = (data["transactionAmount"] ?? 0) / 100;
          var valueOne = data['meterValues']["1"]["value"] ?? 0.00;
          var valueTwo = data['meterValues']["${data['meterValues'].length}"]
                  ["value"] ??
              0.00;
          unitUsed = (valueTwo - valueOne) / 1000;
          DateTime startTime =
              DateTime.parse(data['meterValues']["1"]["timeStamp"]);
          DateTime endTime = DateTime.parse(data['meterValues']
              ["${data['meterValues'].length}"]["timeStamp"]);
          transactionTime =
              endTime.difference(startTime).toString().split(".")[0];
        });
        //print( "chargerName $chargerName, transactionAmount $transactionAmount ");
      } else {
        //print("Error: ${response.statusCode} ");
      }
    } catch (e) {
      //print("Error : ${e.toString()} ");
    }
  }

  // String? TRNID;

  NotificationService notificationService = NotificationService();

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state)async {
  //   super.didChangeAppLifecycleState(state);
  //   final storage = FlutterSecureStorage();
  //   TRNID =  await storage.read(key: "TRNID");
  //   if(TRNID != null){
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       //print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       notificationService.initializeNotification();
  //       notificationService.sendNotification(context,
  //           "Bharat Plug is charging your vehicle...", "thanks for connect us");
  //
  //       //print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       //print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       //print("app in detached");
  //       break;
  //     case AppLifecycleState.hidden:
  //        //print("app in hidden");
  //       break;
  //   }
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    storage.write(key: 'TRNID', value: widget.TRNID);
    getChargingData();
    Future.delayed(Duration(seconds: 2), () {
      getChargingData();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int a = 0;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        a++;
        //print("api calling getting data : $a");
        getChargingData();
      });
    });
    return WillPopScope(
      onWillPop: () async {
        await Permission.notification.isDenied.then((value) {
          if (value) {
            Permission.notification.request();
          }
        });
        notificationService.initializeNotification();
        notificationService.sendNotification(context,
            "Bharat Plug is charging your vehicle...", "thanks for connect us");

        // FlutterBackgroundService().invoke("SetAsForeground");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Charge'),
          ),
          body: Column(
            children: [
              //Container for bike/car name and charge text
              SizedBox(
                  height: Get.height * 0.15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('$chargerName',
                          style: TextStyle(
                              color: Colors.grey, fontSize: Get.width * 0.07)),
                      unitUsed == 0.00 || unitUsed == 0
                          ? Text(
                              'Starting...',
                              style: TextStyle(
                                  fontSize: Get.width * 0.06,
                                  color: Components.green),
                            )
                          : Text(
                              'Your Vehicle is being charged',
                              style: TextStyle(
                                  fontSize: Get.width * 0.06,
                                  color: Components.green),
                            )
                    ],
                  )),

              //Container for charging indicator (circular avatar)
              SizedBox(
                height: Get.height * 0.4,
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200)),
                    elevation: 6,
                    child: CircleAvatar(
                      radius: Get.height * 0.16,
                      backgroundColor: const Color.fromARGB(255, 238, 255, 254),
                      child: LiquidCircularProgressIndicator(
                        value: percent / 100,
                        // Defaults to 0.5.
                        valueColor:
                            AlwaysStoppedAnimation(Colors.green.shade300),
                        backgroundColor: Colors.white,
                        borderColor: Colors.green.shade200,
                        borderWidth: 4.0,
                        direction: Axis.vertical,
                        center: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.electric_bolt,
                                color: Colors.yellow,
                                size: 50,
                              ),
                              Text(
                                '${unitUsed.toStringAsFixed(2)} kw',
                                style: TextStyle(fontSize: Get.width * 0.075),
                              ),
                              const Text(
                                'Energy Consumed',
                                style: TextStyle(color: Colors.black),
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(left: 25.0, right: 15.0),
                child: Row(
                  children: [
                    Text(
                      "Usage",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              //Container for estimated time and price
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  child: Container(
                    height: Get.height * 0.10,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Column for estimated time
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '$transactionTime',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: Get.width * 0.06),
                                  ),
                                  const Text(
                                    'Charging Time',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),

                          //Column for estimated price
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.currency_rupee,
                                        size: Get.width * 0.06,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        '$transactionAmount',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: Get.width * 0.06),
                                      ),
                                    ],
                                  ),
                                  const Text('Cost',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //Container for stop button
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 154, 208, 83),
                          width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(Get.width * 0.05),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return StopChargingAlertPopUp(
                              TRNID: widget.TRNID,
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.stop,
                            size: Get.width * 0.08,
                            color: const Color.fromARGB(255, 154, 208, 83),
                          ),
                          Text(
                            'Stop',
                            style: TextStyle(
                                fontSize: Get.width * 0.06,
                                color: const Color.fromARGB(255, 154, 208, 83)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
