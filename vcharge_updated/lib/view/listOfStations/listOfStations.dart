// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls, unnecessary_null_comparison, duplicate_ignore

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vcharge/models/chargerModel.dart';
import 'package:vcharge/models/connectorModel.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/services/getMethod.dart';
import 'package:vcharge/utils/availabilityColorFunction.dart';
import 'dart:math' as Math;
import 'package:vcharge/view/connectivity_service.dart';
import 'package:vcharge/view/listOfStations/widgets/searchBarOfLOS.dart';
import 'package:vcharge/view/stationsSpecificDetails/stationsSpecificDetails.dart';
import '../../services/urls.dart';

// ignore: must_be_immutable
class ListOfStations extends StatefulWidget {
  String userId;

  ListOfStations({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => ListOfStationsState();
}

class ListOfStationsState extends State<ListOfStations> {
  final ConnectivityService _connectivityService = ConnectivityService();
  static List<RequiredStationDetailsModel> stationsData = [];
  static List<RequiredStationDetailsModel> matchingStations = [];
  static List<RequiredStationDetailsModel> sortedStationList = [];
  LatLng? userPosition;
  bool isLoading = true;
  String getStationUrl =
      '${Urls().stationUrl}/manageStation/getStationInterface';

  @override
  void initState() {
    super.initState();
    getLocationOfUser();
    _checkConnectivity();
    if (mounted) {
      sortStationList();
    }
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  updateFilters(Map<String, dynamic> filters) {
    stationsData = sortedStationList;
    matchingStations.clear();
    //print("stationsData available: ${stationsData.length}");
    //print("sortedStationList available: ${sortedStationList.length}");
    String? station = filters['stationMode']; //
    String? charger = filters['showAvailableChargersOnly']; //
    String? chargerType = filters['chargerType']; //
    List? connectorType = filters['selectedConnectorType']; //

    getFilter(station, charger, chargerType, connectorType);

    sortedStationList.clear();
    for (int a = 0; a < matchingStations.length; a++) {
      sortedStationList.add(matchingStations[a]);
    }
  }

  static getFilter(String? stationAccessType, String? chargerAvailability,
      String? chargerType, List? connectorType) {
    //print("testing data  ========== $stationAccessType $chargerAvailability $chargerType $connectorType");
    stationsData.forEach((singleStation) {
      if (stationAccessType == singleStation.stationParkingType ||
          stationAccessType == null) {
        singleStation.chargers!.length != 0
            ? singleStation.chargers!.forEach((singleCharger) {
                if ((singleCharger.chargerStatus == chargerAvailability ||
                        chargerAvailability == null) &&
                    (singleCharger.chargerType == chargerType ||
                        chargerType == null)) {
                  singleCharger.connectors!.length != 0
                      ? singleCharger.connectors!.forEach((singleConnector) {
                          connectorType != null
                              ? connectorType.forEach((type) {
                                  if ((singleConnector.connectorType == type) ||
                                      type == null) {
                                    //print(" if wale  stationParkingType : ${singleStation.stationParkingType} chargerStatus : ${singleCharger.chargerStatus}  chargerType : ${singleCharger.chargerType}"); //connectorType : ${singleConnector.connectorType} ");
                                    // matchingStations.add(singleStation);
                                    checkList(singleStation);
                                  }
                                })
                              : connectorType == null
                                  ? checkList(singleStation)
                                  : print(
                                      ""); // matchingStations.add(singleStation)
                        })
                      : connectorType == null
                          ? checkList(singleStation)
                          : print("");
                }
              })
            : chargerAvailability == null &&
                    chargerType == null &&
                    connectorType == null
                ? checkList(singleStation)
                : print("");
      }
    });

    //print("matchingStations : ${matchingStations.length}");
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
                child: const Text('Retry'),
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

  @override
  void dispose() {
    super.dispose();
  }

  //this list store the list of stations
  List<RequiredStationDetailsModel> stationsList = [];

  List<ConnectorModel> connectorList = [];
  List<ChargerModel> chargerList = [];

  //this list store the distance for user to each station
  List<double> userToStationDistanceList = [];

  //this list store the list of station and distance
  static List<Map<String, dynamic>> sortedStationDistanceList = [];

  //this list container the list of sorted station

  //this list container the list of sorted distance according to station
  static List<double> sortedDistanceList = [];
  static List<ConnectorModel> connectorsList = [];

  //get current location of the user
  Future<void> getLocationOfUser() async {
    try {
      userPosition = const LatLng(18.551980, 73.956610);
    } catch (e) {
      if (mounted) {
        setState(() {
          userPosition = const LatLng(18.551980, 73.956610);
        });
      }
    }
  }

  Future<void> getStationList(BuildContext context, String url) async {
    try {
      var data = await GetMethod.getRequest(context, url);
      if (data.isNotEmpty) {
        stationsList.clear();
        for (int i = 0; i < data.length; i++) {
          stationsList.add(RequiredStationDetailsModel.fromJson(data[i]));
        }
        if (mounted) {
          setState(() {
            //print(" stationsList is  : ${stationsList.length}");
          });
        }
      } else {
        //print("Empty Data");
      }
    } catch (e) {
      //print(e);
    } finally {
      isLoading = false;
    }
  }

  //To calculate the distance between two points on the Earth's surface given their latitude and longitude coordinates, you can use the Haversine formula.
  double getDistanceFromUser(LatLng latLng1, LatLng latLng2) {
    // convert decimal degrees to radians
    double lat1 = latLng1.latitude;
    double lon1 = latLng1.longitude;
    double lat2 = latLng2.latitude;
    double lon2 = latLng2.longitude;

    var R = 6371;
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d;
  }

  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  }

  Future<void> getDistanceList() async {
    await getStationList(context, getStationUrl);

    userToStationDistanceList = stationsList.map((station) {
      return getDistanceFromUser(
          userPosition!, const LatLng(18.551980, 73.956610));
    }).toList();
  }

  Future<void> sortStationList() async {
    stationsList.clear();
    userToStationDistanceList.clear();
    sortedStationDistanceList.clear();
    sortedStationList.clear();
    sortedDistanceList.clear();

    await getDistanceList();
    sortedStationDistanceList = List.generate(
      stationsList.length,
      (index) => {
        'station': stationsList[index],
        'distance': userToStationDistanceList[index]
      },
    );

    sortedStationDistanceList
        .sort((a, b) => a['distance'].compareTo(b['distance']));
    if (mounted) {
      setState(() {
        for (int i = 0; i < sortedStationDistanceList.length; i++) {
          sortedStationList.add(sortedStationDistanceList[i]['station']);
          sortedDistanceList.add(sortedStationDistanceList[i]['distance']);
        }
      });
    }
    //print("sortedStationDistanceList : ${sortedStationDistanceList[0]['stations']}");
  }

  String getConnectorImage(String? connectorType) {
    switch (connectorType?.toLowerCase()) {
      case 'ccs':
        return 'assets/images/CSSCombo.png';
      case 'chademo':
        return 'assets/images/CHAdeMO.png';
      case 'type 2':
        return 'assets/images/Type2.png';
      case 'type 1':
        return 'assets/images/Type1.png';
      default:
        return 'assets/images/Type1.png';
    }
  }

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    //print("this is sortedStationList :${sortedStationList.length}");
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Stations'),
              actions: [
                InkWell(
                  onTap: () async {
                    setState(() {
                      getLocationOfUser();
                      _checkConnectivity();
                      if (mounted) {
                        sortStationList();
                        //print("sortedStationList : ${sortedStationList.length}");
                      }
                      Future.delayed(const Duration(seconds: 10), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    });
                    //print("refresh");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : const Icon(
                            Icons.refresh,
                            size: 30,
                            color: Colors.white,
                          ),
                  ),
                )
              ],
            ),
            extendBodyBehindAppBar: true,
            body: RefreshIndicator(
                key: refreshkey,
                onRefresh: () async {
                  setState(() {
                    getLocationOfUser();
                    _checkConnectivity();
                    if (mounted) {
                      sortStationList();
                      //print("sortedStationList : ${sortedStationList.length}");
                    }
                    Future.delayed(const Duration(seconds: 10), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  });
                  //print("refresh");
                },
                child: CustomScrollView(slivers: <Widget>[
                  SliverFillRemaining(
                    child: SafeArea(
                      child: Wrap(children: [
                        Container(
                          margin: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.04),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: SearchBarofLOS(
                              userId: widget.userId,
                              callback: (val) =>
                                  setState(() => updateFilters(val))),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.90,
                          child: isLoading
                              ? Center(
                                  child: LoadingAnimationWidget.inkDrop(
                                      color: Colors.green, size: 40),
                                )
                              : sortedStationList.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Lottie.asset(
                                                'assets/images/NoData.json'),
                                          ),
                                          const Center(
                                            child: Text(
                                              "No Stations are Available !",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: sortedStationList.length,
                                      itemBuilder: (context, index) {
                                        if (sortedStationList[index].chargers !=
                                                null &&
                                            sortedStationList[index]
                                                .chargers!
                                                .isNotEmpty) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StationsSpecificDetails(
                                                    stationId:
                                                        sortedStationList[index]
                                                            .stationId!,
                                                    userId: widget.userId,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                elevation: 4,
                                                margin: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                ),
                                                child: Column(children: [
                                                  ListTile(
                                                    title: Text(
                                                      sortedStationList[index]
                                                          .stationName!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      sortedStationList[index]
                                                          .stationArea!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Wrap(
                                                          spacing: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                          children: [
                                                            // ignore: unnecessary_null_comparison
                                                            sortedDistanceList[
                                                                        index] ==
                                                                    null
                                                                ? LoadingAnimationWidget
                                                                    .inkDrop(
                                                                        color: Colors
                                                                            .green,
                                                                        size:
                                                                            40)
                                                                : Text(
                                                                    '${sortedDistanceList[index].toStringAsFixed(2)} KM',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                            CircleAvatar(
                                                              radius: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.02,
                                                              backgroundColor:
                                                                  AvaliblityColor
                                                                      .getAvailablityColor(
                                                                sortedStationList[
                                                                        index]
                                                                    .stationStatus!,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (sortedStationList[index]
                                                              .chargers !=
                                                          null &&
                                                      sortedStationList[index]
                                                          .chargers!
                                                          .isNotEmpty)
                                                    const Divider(
                                                      color: Colors.grey,
                                                      thickness: 1.0,
                                                    ),
                                                  if (sortedStationList[index]
                                                              .chargers !=
                                                          null &&
                                                      sortedStationList[index]
                                                          .chargers!
                                                          .isNotEmpty)
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        for (var charger
                                                            in sortedStationList[
                                                                    index]
                                                                .chargers!)
                                                          if (charger.connectors !=
                                                                  null &&
                                                              charger
                                                                  .connectors!
                                                                  .isNotEmpty)
                                                            for (var connector
                                                                in charger
                                                                    .connectors!)
                                                              ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  radius: 20.0,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          getConnectorImage(
                                                                              connector.connectorType)),
                                                                ),
                                                                title: Text(
                                                                  '${connector.connectorType}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.04,
                                                                  ),
                                                                ),
                                                                subtitle: Text(
                                                                  '${connector.connectorSocket}',
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                trailing: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    if (connector
                                                                            .connectorStatus ==
                                                                        'Available')
                                                                      const Text(
                                                                        'Available',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.green,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    if (connector
                                                                            .connectorStatus ==
                                                                        'Unavailable')
                                                                      const Text(
                                                                        'Unavailable',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    Icon(
                                                                      Icons
                                                                          .keyboard_arrow_right,
                                                                      size: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.07,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                ])),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                        )
                      ]),
                    ),
                  ),
                ]))));
  }

  static checkList(RequiredStationDetailsModel singleStation) {
    matchingStations.isNotEmpty
        ? matchingStations.addIf(
            !matchingStations.contains(singleStation), singleStation)
        : matchingStations.add(singleStation);
  }
}
