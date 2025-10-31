// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vcharge/models/chargingHistoryModel.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/view/ChargingHistory/Widgets/ChargingHistoryDetailsPopUp.dart';

import '../../services/urls.dart';
import '../connectivity_service.dart';

class ChargingHistoryScreen extends StatefulWidget {
  @override
  _ChargingHistoryScreenState createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen> {
  List<ChargingHistoryModel> chargingHistoryList = [];
  final ConnectivityService _connectivityService = ConnectivityService();
  bool isLoading = true;
  Future<void> fetchData() async {
    try {
      const storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      final url = Uri.parse(
          '${Urls().transactionUrl}/manageTransaction/getTransactions?transactionCustomerId=$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chargingHistoryList = List<ChargingHistoryModel>.from(
              data.map((json) => ChargingHistoryModel.fromJson(json)));
        });
      } else {
        //print('Failed to load data from the API');
      }
    } catch (e) {
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<StationModel> fetchStationDetails(String stationId) async {
    final stationDetailsUrl = Uri.parse(
        '${Urls().stationUrl}/manageStation/getStation?stationId=$stationId');
    final stationDetailsResponse = await http.get(stationDetailsUrl);

    if (stationDetailsResponse.statusCode == 200) {
      final stationDetails =
          StationModel.fromJson(json.decode(stationDetailsResponse.body));
      return stationDetails;
    } else {
      // Handle the error or return a default StationModel
      return StationModel();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _checkConnectivity();
    Future.delayed(Duration(seconds: 10), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
                'Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      const snackBar = SnackBar(
        content: Text('No internet connection'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging History'),
      ),
      body: isLoading
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.green, size: 40),
            )
          : chargingHistoryList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Lottie.asset('assets/images/NoData.json'),
                      ),
                      const Text(
                        "No Data Available !",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  key: refreshkey,
                  onRefresh: () async {
                    setState(() {
                      fetchData();
                      _checkConnectivity();
                    });
                    //print("refresh");
                  },
                  child: ListView.builder(
                    itemCount: chargingHistoryList.length,
                    itemBuilder: (context, index) {
                      final chargingHistory = chargingHistoryList[index];

                      return FutureBuilder<StationModel>(
                        future: fetchStationDetails(
                            chargingHistory.transactionStationId ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final stationDetails =
                                snapshot.data ?? StationModel();
                            final startTime = DateTime.tryParse(chargingHistory
                                    .transactionMeterStartTimeStamp ??
                                "");
                            final stopTime = DateTime.tryParse(
                                chargingHistory.transactionMeterStopTimeStamp ??
                                    "");

                            if (startTime != null && stopTime != null) {}
                            return InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return ChargingHistoryDetailsPopUp(
                                      transactionDetails: chargingHistory,
                                      stationDetails: stationDetails,
                                    );
                                  },
                                );
                              },
                              child: Card(
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color:
                                      const Color.fromARGB(255, 246, 249, 252),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.02,
                                      vertical: Get.height * 0.01),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${stationDetails.stationName}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            if (chargingHistory
                                                    .transactionAmount !=
                                                null)
                                              Card(
                                                  color: const Color.fromARGB(
                                                      255, 246, 249, 252),
                                                  elevation: 0,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                Get.height *
                                                                    0.004,
                                                            horizontal:
                                                                Get.width *
                                                                    0.015),
                                                    child: Text(
                                                      '${chargingHistory.transactionAmount} Rs.',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                          ],
                                        ),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //Column booking status
                                            Expanded(
                                              child: SizedBox(
                                                height: Get.height * 0.07,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      'Transaction Status',
                                                      style: TextStyle(
                                                          fontSize:
                                                              Get.width * 0.035,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Card(
                                                        elevation: 0,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 221, 243, 222),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      Get.height *
                                                                          0.004,
                                                                  horizontal:
                                                                      Get.width *
                                                                          0.015),
                                                          child: Text(
                                                            chargingHistory
                                                                        .transactionStatus ==
                                                                    "EVDisconnected"
                                                                ? "Fully charged or Disconnected"
                                                                : chargingHistory
                                                                    .transactionStatus!,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Get.width *
                                                                        0.03),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        //Wrap for amount paid
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: Get.height * 0.004),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              //Row for amount paid

                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.004),
                                                child: Wrap(
                                                  spacing: 20,
                                                  children: [
                                                    Text(
                                                        DateFormat(
                                                                "dd MMM, yyyy")
                                                            .format(
                                                                DateTime.parse(
                                                          '${chargingHistory.transactionMeterStartTimeStamp}',
                                                        )),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                        "${DateFormat("hh:mm a ").format(DateTime.parse(chargingHistory.transactionMeterStartTimeStamp!))}-${DateFormat(" hh:mm a ").format(DateTime.parse(chargingHistory.transactionMeterStopTimeStamp!))}",
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          } else {
                            return Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: Colors.green, size: 40),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
