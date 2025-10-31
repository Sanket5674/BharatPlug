import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vcharge/services/GetMethod.dart';
import '../../services/urls.dart';
import '../startChargingScreen/startChargingScreen.dart';
import '../walletScreen/addMoneyScreen.dart';

// ignore: must_be_immutable
class ChargingScreen extends StatefulWidget {
  String stationName;
  String stationLocation;
  String userId;
  String stationId;
  String chargerId;
  String connectorId;

  ChargingScreen({
    required this.userId,
    required this.stationLocation,
    required this.stationName,
    super.key,
    required this.stationId,
    required this.chargerId,
    required this.connectorId,
    required String chargerSerialNumber,
    required String connectorNumber,
  });

  @override
  State<StatefulWidget> createState() => ChargingScreenState();
}

class ChargingScreenState extends State<ChargingScreen> {
  //activeButton to track time, units and money activeness
  //1 = time, 2 = units and 3 = money
  int activeButton = 1;
  int timeSliderValue = 6;
  int unitsSliderValue = 100;
  int moneySliderValue = 1000;

// boolean variable for keeping track of the toggling effect
  bool customizeToggle = false;

// variable for keeping the track of the wallet amount
  // ignore: prefer_typing_uninitialized_variables
  var walletAmount;
  final storage = const FlutterSecureStorage();
// init state method to call the getWalletAmount method
  @override
  void initState() {
    getWalletAmount();
    super.initState();
  }

// function for fetching the wallet amount
  Future<void> getWalletAmount() async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getWalletByUserId?userId=${widget.userId}');
      if (data != null) {
        setState(() {
          walletAmount = data['walletAmount'].toString();
        });
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  startChargingCall() async {
    try {
      final userId = await storage.read(key: 'userId');
      final requestBody = {
        "userId": "$userId",
        "idTag": "$userId",
        "connectorNumber": "1",
        "chargerSerialNumber": "VPEL",
        "modeOfCharging": "fullCharge"
      };

      final requestBodyJson = json.encode(requestBody);

      final apiUrl = Uri.parse(
          '${Urls().transactionUrl}/manageTransaction/startTransactionRequest');

      final response = await http.post(apiUrl,
          headers: {'Content-Type': 'application/json'}, body: requestBodyJson);

      if (response.statusCode == 200) {
        if (response.body.toString() != "exist" &&
            response.body.toString() != "unavailable") {
          //print("this is TRNID: ${TRNID}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartChargingScreen(
                        TRNID: response.body,
                      )));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text('${response.body.toString()}'),
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
        //Components().showSnackbar(Components().something_want_wrong, context);
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print("Error : ${e}");
    }
  }

  Future<void> startCharge() async {
    var getResponse = await GetMethod.getRequestMod(
        context, 'http://192.168.0.44:8080/remoteStartTransaction');
    //print('$getResponse');
    if (jsonDecode(getResponse.body)) {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const StartChargingScreen()));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Something went wrong'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Charge'),
      ),
      body: Column(
        children: [
          //Expanded for station Name
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.stationName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.06),
                ),
              ),
            ),
          ),

          //Container for address, car and bike, charger type, cost
          Expanded(
            flex: 13,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Container for station address
                  Row(
                    children: [
                      //container for location Icon
                      const Expanded(
                        flex: 2,
                        child: Icon(Icons.directions),
                      ),

                      //container for station address text
                      Expanded(
                        flex: 14,
                        child: Text(
                          widget.stationLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Container for car name
                  const Row(
                    children: [
                      //container for car or bike Icon
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.electric_bike),
                      ),
                      //conteiner for car or bike name
                      Expanded(
                        flex: 14,
                        child: Text(
                          'Revolt RV 300',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Container for charger type
                  const Row(
                    children: [
                      //container for charger icon
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.charging_station),
                      ),
                      //container for charger type and watt
                      Expanded(
                        flex: 14,
                        child: Text(
                          'AC, 3.3 kWh',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Container for charging cost
                  const Row(
                    children: [
                      //container for rupee icon
                      Expanded(
                        flex: 2,
                        child: Icon(Icons.currency_rupee),
                      ),
                      //container for cost price of charger
                      Expanded(
                        flex: 14,
                        child: Text(
                          'Cost: 15 rs/kW',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          //Container contains 2 container based on customizeToggle
          Expanded(
              flex: 32,
              child: customizeToggle
                  ?
                  //Container for Time slider, Units slider and Money slider
                  //this container will show when the customizeToggle is true
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Expanded for time, units and money buttons
                        Expanded(
                          flex: 10,
                          child: Container(
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 2,
                                    color: const Color.fromARGB(
                                        255, 146, 204, 81))),
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
                        ),

                        //constainer for 'How long will you charge ?' text
                        Expanded(
                          flex: 8,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.005),
                            child: Center(
                              child: Text(
                                'How long will you charge ?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                            ),
                          ),
                        ),

                        //sliders
                        Expanded(
                          flex: 38,
                          child: Column(
                            children: [
                              activeButton == 1
                                  ?
                                  //Container for Time slider
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
                                              //Container for set limit text
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
                                              //silder
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  child: Slider(
                                                    min: 1,
                                                    max: 6,
                                                    divisions: 6,
                                                    inactiveColor:
                                                        const Color.fromARGB(
                                                            255, 191, 235, 141),
                                                    activeColor:
                                                        const Color.fromARGB(
                                                            255, 146, 204, 81),
                                                    value: timeSliderValue
                                                        .toDouble(),
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
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                    color: const Color.fromARGB(
                                                        255, 146, 204, 81)),
                                              ),
                                            ]),
                                      ),
                                    )
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  //container for set limit text
                                                  Text(
                                                    'Set Limit',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                  ),
                                                  //slider
                                                  SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      activeTrackColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      thumbColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      overlayColor:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  146,
                                                                  204,
                                                                  81)
                                                              .withOpacity(0.2),
                                                    ),
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        valueIndicatorColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                146, 204, 81),
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
                                                            const Color
                                                                .fromARGB(255,
                                                                191, 235, 141),
                                                        activeColor: const Color
                                                            .fromARGB(
                                                            255, 146, 204, 81),
                                                        value: unitsSliderValue
                                                            .toDouble(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            unitsSliderValue =
                                                                newValue
                                                                    .toInt();
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
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.06,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 146, 204, 81)),
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  //container for set limit text
                                                  Text(
                                                    'Set Limit',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                  ),
                                                  //slider
                                                  SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      activeTrackColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      inactiveTrackColor:
                                                          Colors.grey,
                                                      thumbColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              146,
                                                              204,
                                                              81),
                                                      overlayColor:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  146,
                                                                  204,
                                                                  81)
                                                              .withOpacity(0.2),
                                                    ),
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(
                                                              context)
                                                          .copyWith(
                                                        valueIndicatorColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                146, 204, 81),
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
                                                            const Color
                                                                .fromARGB(255,
                                                                191, 235, 141),
                                                        activeColor: const Color
                                                            .fromARGB(
                                                            255, 146, 204, 81),
                                                        value: moneySliderValue
                                                            .toDouble(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            moneySliderValue =
                                                                newValue
                                                                    .toInt();
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
                                                        MainAxisAlignment
                                                            .center,
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
                        ),

                        //Container for estimated price
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.06),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Estimated Price:'),
                                Text(
                                  'Rs 200 Inc Taxes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  :
                  //Container for current charging, full charge button and estimated time, units and cost
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Expanded for current charging and start charging
                        Expanded(
                          child: Row(
                            children: [
                              //Container for current charging
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: CircleAvatar(
                                        radius: Get.height * 0.07,
                                        backgroundColor: const Color.fromARGB(
                                            255, 247, 255, 254),
                                        child: const Center(
                                          child: Text(
                                            '30%',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Current Charging',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),

                              //Container for start charging
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Card(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: InkWell(
                                        onTap: () {
                                          startChargingCall();
                                          // await startCharge();
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const StartChargingScreen()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(
                                              255, 179, 223, 102),
                                          radius: Get.height * 0.07,
                                          child: Center(
                                            child: Text(
                                              'Start',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: Get.height * 0.03),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'Full Charge',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Container for estimated time money and units etc.
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Row for estimated time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Time',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.045),
                                  ),
                                  Text(
                                    '21 Mins',
                                    style:
                                        TextStyle(fontSize: Get.width * 0.045),
                                  ),
                                ],
                              ),

                              //Row for estimated cost
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Cost',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.045),
                                  ),
                                  Text(
                                    'Rs. 190 Inc Taxes',
                                    style:
                                        TextStyle(fontSize: Get.width * 0.045),
                                  ),
                                ],
                              ),

                              //Row for estimated Units
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated Units',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: Get.width * 0.045),
                                  ),
                                  Text(
                                    '28 Units',
                                    style:
                                        TextStyle(fontSize: Get.width * 0.045),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                      ],
                    )),

          //Container for Customize toggle button
          Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Customize Charging',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                      value: customizeToggle,
                      onChanged: (newValue) {
                        setState(() {
                          customizeToggle = newValue;
                        });
                      })
                ],
              ),
            ),
          ),

          //Container for wallet balance and credit button
          Expanded(
            flex: 6,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.06, vertical: Get.height * 0.004),
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text('Wallet balance is '),
                        //rupees icon
                        Icon(
                          Icons.currency_rupee,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                        walletAmount == null
                            ? LoadingAnimationWidget.inkDrop(
                                color: Colors.green, size: 40)
                            : Text(
                                walletAmount!,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045),
                              ),
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddMoneyScreen(userId: widget.userId)));
                        },
                        child: const Text(
                          'Credit',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ),

          //Container for start charging button
          Expanded(
            flex: 8,
            child: Visibility(
              visible: customizeToggle,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06, vertical: Get.height * 0.02),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 146, 204, 81)),
                    onPressed: () {
                      startChargingCall();
                      // await startCharge();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>
                      //             const StartChargingScreen()));
                    },
                    child: const Text('Start Charging')),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
