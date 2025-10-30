// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/services/StartChargingService.dart';
import '../../services/urls.dart';
import '../components.dart';
import '../stationsSpecificDetails/widgets/timeUnitMoney.dart';

// ignore: must_be_immutable
class QRScannerWidget extends StatefulWidget {
  String userId;
  QRScannerWidget({required this.userId, super.key});

  @override
  _QRScannerWidgetState createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  var stationCodeController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanStarted = false;
  bool flashOnOff = false;
  String scanResult = " ";
  int activeButton = 1;
  int timeSliderValue = 0;
  int unitsSliderValue = 0;
  int moneySliderValue = 0;
  final storage = const FlutterSecureStorage();
  bool showScannerWidget = true;

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void startScanner() async {
    try {
      if (controller != null) {
        await controller?.resumeCamera();
        setState(() {
          scanStarted = true;
        });
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print("The error at the scanner is: $e");
    }
  }

  void stopScanner() async {
    try {
      if (controller != null) {
        await controller?.pauseCamera();
        setState(() {
          scanStarted = false;
        });
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  String stationId = "";
  String chargerId = "";
  String connectorId = "";
  String status = "";

  void getStationData(
      String chargerSerialNumber, String connectorNumber) async {
    try {
      final response = await http.get(Uri.parse(
          "${Urls().stationUrl}/manageStation/getStationByChargerSerialNumber?chargerSerialNumber=$chargerSerialNumber&connectorNumber=$connectorNumber"));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          stationId = data['stationId'].toString();
          chargerId = data['chargerId'].toString();
          connectorId = data['connectorId'].toString();
          status = data['connectorStatus'].toString();
          showScannerWidget = false;
        });

        if (status == "Available") {
          if (stationId != "" && chargerId != "" && connectorId != "") {
            showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // used to handle the onFocus() activities
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            // margin: const EdgeInsets.only(top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 60,
                                  child: Divider(
                                    color: Colors.green,
                                    thickness: 3,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Want to go for a full charge?",
                                    style: TextStyle(
                                      fontSize: 23,
                                    ),
                                  ),
                                ),

                                // button for Start Charging
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    onTap: () async {
                                      var start = StartChargingService(context);
                                      final userId =
                                          await storage.read(key: 'userId');
                                      start.startChargingApiCall(
                                          "$userId",
                                          "$userId",
                                          connectorNumber,
                                          chargerSerialNumber,
                                          0,
                                          0,
                                          0,
                                          "fullCharging");
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            border: Border.all(
                                                color: Colors.green,
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            )),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            "Start Charging",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),

                                // button for Customaization
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(30.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Wrap(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20.0),
                                                      topRight:
                                                          Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // used to handle the onFocus() activities
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                    },
                                                    child: Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const SizedBox(
                                                            width: 60,
                                                            child: Divider(
                                                              color:
                                                                  Colors.green,
                                                              thickness: 3,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),

                                                          TimeUnitMoney(
                                                              userId:
                                                                  widget.userId,
                                                              connectorIndex:
                                                                  connectorNumber,
                                                              activeButton:
                                                                  activeButton,
                                                              timeSliderValue:
                                                                  timeSliderValue,
                                                              unitsSliderValue:
                                                                  unitsSliderValue,
                                                              moneySliderValue:
                                                                  moneySliderValue),

                                                          const SizedBox(
                                                            height: 30,
                                                          ),

                                                          // added so that when keyboard pops up, sheet should not hide behind
                                                          Padding(
                                                              padding: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return AlertDialog(
                                      //         content: Text(
                                      //             'We will take a value which you select at last.'),
                                      //         actions: [
                                      //           ElevatedButton(
                                      //               onPressed: () {
                                      //                 Navigator.of(context)
                                      //                     .pop();
                                      //                 showModalBottomSheet(
                                      //                   isScrollControlled:
                                      //                       true,
                                      //                   shape:
                                      //                       const RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .vertical(
                                      //                       top:
                                      //                           Radius.circular(
                                      //                               30.0),
                                      //                     ),
                                      //                   ),
                                      //                   context: context,
                                      //                   builder: (BuildContext
                                      //                       context) {
                                      //                     return Container(
                                      //                       decoration:
                                      //                           BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     20.0),
                                      //                       ),
                                      //                       child: Wrap(
                                      //                         children: [
                                      //                           Container(
                                      //                             padding: const EdgeInsets
                                      //                                 .symmetric(
                                      //                                 horizontal:
                                      //                                     20.0),
                                      //                             decoration:
                                      //                                 const BoxDecoration(
                                      //                               borderRadius:
                                      //                                   BorderRadius
                                      //                                       .only(
                                      //                                 topLeft: Radius
                                      //                                     .circular(
                                      //                                         20.0),
                                      //                                 topRight:
                                      //                                     Radius.circular(
                                      //                                         20.0),
                                      //                               ),
                                      //                             ),
                                      //                             child:
                                      //                                 GestureDetector(
                                      //                               onTap: () {
                                      //                                 // used to handle the onFocus() activities
                                      //                                 FocusScope.of(
                                      //                                         context)
                                      //                                     .unfocus();
                                      //                               },
                                      //                               child:
                                      //                                   Container(
                                      //                                 alignment:
                                      //                                     Alignment
                                      //                                         .bottomCenter,
                                      //                                 child:
                                      //                                     Column(
                                      //                                   mainAxisAlignment:
                                      //                                       MainAxisAlignment.center,
                                      //                                   children: [
                                      //                                     Container(
                                      //                                       width:
                                      //                                           60,
                                      //                                       child:
                                      //                                           const Divider(
                                      //                                         color: Colors.green,
                                      //                                         thickness: 3,
                                      //                                       ),
                                      //                                     ),
                                      //                                     SizedBox(
                                      //                                       height:
                                      //                                           10,
                                      //                                     ),
                                      //
                                      //                                     TimeUnitMoney(
                                      //                                         userId: widget.userId,
                                      //                                         connectorIndex: connectorNumber,
                                      //                                         activeButton: activeButton,
                                      //                                         timeSliderValue: timeSliderValue,
                                      //                                         unitsSliderValue: unitsSliderValue,
                                      //                                         moneySliderValue: moneySliderValue),
                                      //
                                      //                                     SizedBox(
                                      //                                       height:
                                      //                                           30,
                                      //                                     ),
                                      //
                                      //                                     // added so that when keyboard pops up, sheet should not hide behind
                                      //                                     Padding(
                                      //                                         padding: MediaQuery.of(context).viewInsets)
                                      //                                   ],
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     );
                                      //                   },
                                      //                 );
                                      //               },
                                      //               child: const Text('OK'))
                                      //         ],
                                      //       );
                                      //     });

                                      // showModalBottomSheet(
                                      //   isScrollControlled: true,
                                      //   shape: const RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.vertical(
                                      //       top: Radius.circular(30.0),
                                      //     ),
                                      //   ),
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return Container(
                                      //       decoration: BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(20.0),
                                      //       ),
                                      //       child: Wrap(
                                      //         children: [
                                      //           Container(
                                      //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      //             decoration: const BoxDecoration(
                                      //               borderRadius: BorderRadius.only(
                                      //                 topLeft: Radius.circular(20.0),
                                      //                 topRight: Radius.circular(20.0),
                                      //               ),
                                      //             ),
                                      //             child: GestureDetector(
                                      //               onTap: () {
                                      //                 // used to handle the onFocus() activities
                                      //                 FocusScope.of(context).unfocus();
                                      //               },
                                      //               child: Container(
                                      //                 alignment: Alignment.bottomCenter,
                                      //                 child: Column(
                                      //                   mainAxisAlignment: MainAxisAlignment.center,
                                      //                   children: [
                                      //                     Container(
                                      //                       width: 60,
                                      //                       child: const Divider(
                                      //                         color: Colors.green,
                                      //                         thickness: 3,
                                      //                       ),
                                      //                     ),
                                      //                     SizedBox(
                                      //                       height: 10,
                                      //                     ),
                                      //
                                      //                     TimeUnitMoney(userId: widget.userId,connectorIndex: connectorNumber,activeButton: activeButton,timeSliderValue: timeSliderValue,unitsSliderValue: unitsSliderValue,moneySliderValue: moneySliderValue),
                                      //
                                      //                     SizedBox(
                                      //                       height: 30,
                                      //                     ),
                                      //
                                      //                     // added so that when keyboard pops up, sheet should not hide behind
                                      //                     Padding(padding: MediaQuery.of(context).viewInsets)
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   },
                                      // );
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.green,
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            )),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Customize",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.green),
                                                ),
                                              ],
                                            ))),
                                  ),
                                ),

                                const SizedBox(
                                  height: 30,
                                ),

                                // added so that when keyboard pops up, sheet should not hide behind
                                Padding(
                                    padding: MediaQuery.of(context).viewInsets)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('$status'),
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
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('${response.statusCode}'),
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
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      showSnackbar("Error : ${e.toString()}");
      //print(e);
    }
  }

  Future<void> flashLightOn(BuildContext context) async {
    try {
      //print(" code to flash light On ");
    } on Exception {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print("Exception in on: $e");
    }
  }

  Future<void> flashLightOff(BuildContext context) async {
    try {
      //print(" code to flash light Off ");
    } on Exception {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print("Exception in off: $e");
    }
  }

  bool isScanned = false;

  void onQRViewCreated(QRViewController controller) async {
    try {
      this.controller = controller;

      // Check for camera permission
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        await Permission.camera.request();
        status = await Permission.camera.status;
      }

      if (status.isGranted) {
        // startScanner();
        controller.scannedDataStream.listen((scanData) async {
          if (isScanned) return;
          try {
            stopScanner();
            controller.stopCamera();

            scanResult = scanData.code!;
            //print("Scanned Result: $scanResult");

            List<String> parts = scanResult.split('/');

            if (parts.length == 2) {
              String chargerSerialNumber = parts[0];
              String connectorNumber = parts[1];

              //print("Charger Serial Number: $chargerSerialNumber");
              //print("Connector Number: $connectorNumber");
              scanResult = "";
              getStationData(chargerSerialNumber, connectorNumber);
              setState(() {
                controller.resumeCamera();
              });
            } else {
              scanResult = "";

              //print("Invalid QR Code Format");
              showSnackbar("Invalid QR Code Format");
              setState(() {
                controller.resumeCamera();
              });
            }
          } catch (e) {
            // Components()
            //     .showSnackbar(Components().something_want_wrong, context);
            //print("Error while processing QR code: $e");
            scanResult = "";
            showSnackbar("Error while processing QR code: $e");
            setState(() {});
          }
        });
      } else {
        scanResult = "";
        // Handle denied permission
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission denied'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      Components().showSnackbar("Error : ${e.toString()}", context);
      //print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        showScannerWidget = true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // Set the background color to transparent

          centerTitle: true,
          title: const Text(
            "Scan and Charge",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            showScannerWidget
                ? Positioned(
                    top: MediaQuery.of(context).size.height * 0.08,
                    left: (MediaQuery.of(context).size.width -
                            MediaQuery.of(context).size.width * 0.8) /
                        2,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 195, 227, 196),
                          width: 3.0,
                        ),
                      ),
                      child: (scanResult == "Failed to scan")
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_scanner,
                                    color: Colors.white, size: 60.0),
                                SizedBox(height: 16.0),
                                Text(
                                  "Failed to scan, please enter the station Id",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            )
                          : QRView(
                              key: qrKey,
                              cameraFacing: CameraFacing.back,
                              overlay: QrScannerOverlayShape(
                                borderRadius: 16.0,
                                borderColor: Colors.white,
                                borderLength: 24.0,
                                borderWidth: 4.0,
                                cutOutSize:
                                    MediaQuery.of(context).size.width * 0.65,
                              ),
                              onQRViewCreated: onQRViewCreated,
                            ),
                    ),
                  )
                : Container(),
            showScannerWidget
                ? Positioned(
                    top: MediaQuery.of(context).size.height * 0.5 + 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          if (flashOnOff) {
                            flashLightOn(context);
                            setState(() {
                              flashOnOff = false;
                            });
                          } else {
                            flashLightOff(context);
                            setState(() {
                              flashOnOff = true;
                            });
                          }
                        },
                        icon: flashOnOff
                            ? const Icon(
                                Icons.flash_on,
                                color: Colors.yellow,
                              )
                            : const Icon(
                                Icons.flash_off,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  )
                : Container(),
            showScannerWidget
                ? Positioned(
                    top: MediaQuery.of(context).size.height * 0.5 + 100,
                    left: 0,
                    right: 0,
                    child: const Text(
                      "------------ OR ------------",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              top: showScannerWidget
                  ? MediaQuery.of(context).size.height * 0.5 + 140
                  : MediaQuery.of(context).size.height * 0.1 + 30,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    "Please enter the station code as seen on the box",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          showScannerWidget = false;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FaIcon(
                            FontAwesomeIcons.gasPump,
                            size: 20,
                            color: Color.fromARGB(255, 51, 50, 50),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        label: Text("Station Code"),
                      ),
                      controller: stationCodeController,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: showScannerWidget
                  ? MediaQuery.of(context).size.height * 0.5 + 245
                  : MediaQuery.of(context).size.height * 0.1 + 135,
              left: MediaQuery.of(context).size.width * 0.35,
              right: MediaQuery.of(context).size.width * 0.35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      if (stationCodeController.text.isNotEmpty) {
                        List<String> parts =
                            stationCodeController.text.split('/');
                        if (parts.length == 2) {
                          String chargerSerialNumber = parts[0];
                          String connectorNumber = parts[1];

                          //print("Charger Serial Number: $chargerSerialNumber");
                          //print("Connector Number: $connectorNumber");
                          stationCodeController.text = "";
                          getStationData(chargerSerialNumber, connectorNumber);
                        } else {
                          //print("Invalid Code Format");
                          showSnackbar("Invalid Code Format");
                        }
                      } else {
                        //print("Code is Empty");
                        showSnackbar("Please Enter Code");
                      }
                    },

                    // onPressed:(){
                    //   Navigator.push(context, MaterialPageRoute(
                    //       builder: (context) => StartChargingScreen(TRNID: "TRN20231123115010065",)));
                    // },
                    label: const Text("Proceed",
                        style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 20),
                  showScannerWidget
                      ? Container()
                      : const Column(
                          children: [
                            Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.green,
                            ),
                            Text(
                              "Open QR Scanner",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.green),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void customizeSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    // used to handle the onFocus() activities
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 60,
                          child: Divider(
                            color: Colors.green,
                            thickness: 3,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        // Container(
                        //   height: 40,
                        //   width: MediaQuery.of(context).size.width,
                        //   alignment: Alignment.center,
                        //   decoration: BoxDecoration(
                        //       border: Border.all(
                        //           color: Colors.green,
                        //           width: 1.0,
                        //           style: BorderStyle.solid),
                        //       borderRadius: BorderRadius.all(
                        //         Radius.circular(5),
                        //       )),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Container(
                        //         alignment: Alignment.center,
                        //         width: 70,
                        //           margin: const EdgeInsets.all(2.0),
                        //     decoration: BoxDecoration(
                        //       color:Colors.green,
                        //           borderRadius: BorderRadius.all(
                        //             Radius.circular(5),
                        //           ),),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text("Time",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        //           )),
                        //       Container(
                        //           width: 70,
                        //           alignment: Alignment.center,
                        //           margin: const EdgeInsets.all(2.0),
                        //           decoration: BoxDecoration(
                        //             color:Colors.green,
                        //             borderRadius: BorderRadius.all(
                        //               Radius.circular(5),
                        //             ),),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text("Unit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        //           )),
                        //       Container(
                        //           width: 70,
                        //           alignment: Alignment.center,
                        //           margin: const EdgeInsets.all(2.0),
                        //           decoration: BoxDecoration(
                        //             color:Colors.green,
                        //             borderRadius: BorderRadius.all(
                        //               Radius.circular(5),
                        //             ),),
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text("Money",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        //           )),
                        //     ],
                        //   ),
                        // ),

                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  width: 2,
                                  color:
                                      const Color.fromARGB(255, 146, 204, 81))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Button for time slider button
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: activeButton == 1 ? 4 : 0,
                                    backgroundColor: activeButton == 1
                                        ? const Color.fromARGB(
                                            255, 146, 208, 80)
                                        : Colors
                                            .transparent, // Set the button color
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      activeButton = 1;
                                    });
                                  },
                                  child: Text('Time',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: activeButton == 1
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  255, 146, 208, 80)))),

                              //button for unit slider button
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: activeButton == 2 ? 4 : 0,
                                    backgroundColor: activeButton == 2
                                        ? const Color.fromARGB(
                                            255, 146, 208, 80)
                                        : Colors
                                            .transparent, // Set the button color
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      activeButton = 2;
                                    });
                                  },
                                  child: Text(
                                    'Units',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: activeButton == 2
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 146, 208, 80)),
                                  )),

                              //button for money slider button
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: activeButton == 3 ? 4 : 0,
                                    backgroundColor: activeButton == 3
                                        ? const Color.fromARGB(
                                            255, 146, 208, 80)
                                        : Colors
                                            .transparent, // Set the button color
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      activeButton = 3;
                                    });
                                  },
                                  child: Text(
                                    'Money',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: activeButton == 3
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                255, 146, 208, 80)),
                                  )),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "How long you will charge?",
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            activeButton == 1
                                ?
                                //Container for Time slider
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                        //Container for set limit text
                                        Text(
                                          'Set Limit',
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                        ),
                                        //silder
                                        SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            activeTrackColor:
                                                const Color.fromARGB(
                                                    255, 146, 204, 81),
                                            inactiveTrackColor: Colors.grey,
                                            thumbColor: const Color.fromARGB(
                                                255, 146, 204, 81),
                                            overlayColor: const Color.fromARGB(
                                                    255, 146, 204, 81)
                                                .withOpacity(0.2),
                                          ),
                                          child: SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                              valueIndicatorColor:
                                                  const Color.fromARGB(
                                                      255, 146, 204, 81),
                                              valueIndicatorTextStyle:
                                                  const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: Slider(
                                              min: 1,
                                              max: 6,
                                              divisions: 6,
                                              inactiveColor:
                                                  const Color.fromARGB(
                                                      255, 191, 235, 141),
                                              activeColor: const Color.fromARGB(
                                                  255, 146, 204, 81),
                                              value: timeSliderValue.toDouble(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  timeSliderValue =
                                                      newValue.toInt();
                                                });
                                              },
                                              label:
                                                  '${timeSliderValue.toStringAsFixed(0)}hr',
                                            ),
                                          ),
                                        ),
                                        //container to show the selected value
                                        Text(
                                          '$timeSliderValue hours',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.06,
                                              color: const Color.fromARGB(
                                                  255, 146, 204, 81)),
                                        ),
                                      ])
                                : activeButton == 2
                                    ?
                                    //Container for Units slider
                                    Container(
                                        height: Get.height * 0.25,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 146, 204, 81)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                //container for set limit text
                                                Text(
                                                  'Set Limit',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  ),
                                                ),
                                                //slider
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    activeTrackColor:
                                                        const Color.fromARGB(
                                                            255, 146, 204, 81),
                                                    inactiveTrackColor:
                                                        Colors.grey,
                                                    thumbColor:
                                                        const Color.fromARGB(
                                                            255, 146, 204, 81),
                                                    overlayColor:
                                                        const Color.fromARGB(
                                                                255,
                                                                146,
                                                                204,
                                                                81)
                                                            .withOpacity(0.2),
                                                  ),
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      valueIndicatorColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      valueIndicatorTextStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    child: Slider(
                                                      min: 1,
                                                      max: 100,
                                                      divisions: 20,
                                                      inactiveColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              191,
                                                              235,
                                                              141),
                                                      activeColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      value: unitsSliderValue
                                                          .toDouble(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          unitsSliderValue =
                                                              newValue.toInt();
                                                        });
                                                      },
                                                      label:
                                                          '${unitsSliderValue.toStringAsFixed(0)} Units',
                                                    ),
                                                  ),
                                                ),

                                                //container to show the selected value
                                                Text(
                                                  '$unitsSliderValue Units',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81)),
                                                ),
                                              ]),
                                        ),
                                      )
                                    :
                                    //Container for Money slider
                                    Container(
                                        height: Get.height * 0.25,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06),
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 146, 204, 81)
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                //container for set limit text
                                                Text(
                                                  'Set Limit',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                  ),
                                                ),
                                                //slider
                                                SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    activeTrackColor:
                                                        const Color.fromARGB(
                                                            255, 146, 204, 81),
                                                    inactiveTrackColor:
                                                        Colors.grey,
                                                    thumbColor:
                                                        const Color.fromARGB(
                                                            255, 146, 204, 81),
                                                    overlayColor:
                                                        const Color.fromARGB(
                                                                255,
                                                                146,
                                                                204,
                                                                81)
                                                            .withOpacity(0.2),
                                                  ),
                                                  child: SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      valueIndicatorColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      valueIndicatorTextStyle:
                                                          const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    child: Slider(
                                                      min: 100,
                                                      max: 1000,
                                                      divisions: 9,
                                                      inactiveColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              191,
                                                              235,
                                                              141),
                                                      activeColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      value: moneySliderValue
                                                          .toDouble(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          moneySliderValue =
                                                              newValue.toInt();
                                                        });
                                                      },
                                                      label:
                                                          '${moneySliderValue.toStringAsFixed(0)} Rs',
                                                    ),
                                                  ),
                                                ),

                                                //container to show the selected value
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '$moneySliderValue',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              146, 204, 81)),
                                                    ),
                                                    const Icon(
                                                        Icons.currency_rupee)
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: InkWell(
                            onTap: () {
                              // startChargingCall("${widget.userId}", "${widget.userId}",connectorNumber, chargerSerialNumber, 0, 0, 0, "", "fullCharging");

                              //API Call for start charging
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //         const StartChargingScreen()));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                        color: Colors.green,
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    )),
                                width: MediaQuery.of(context).size.width * 0.50,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Start Charging",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                )),
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // added so that when keyboard pops up, sheet should not hide behind
                        Padding(padding: MediaQuery.of(context).viewInsets)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
