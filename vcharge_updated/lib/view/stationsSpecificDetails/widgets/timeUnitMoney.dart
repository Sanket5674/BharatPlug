import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../../services/StartChargingService.dart';
import '../../../utils/providers/customize_charging_provider/CustomizeProvider.dart';

// ignore: must_be_immutable
class TimeUnitMoney extends StatefulWidget {
  String userId;
  String connectorIndex;
  int activeButton;
  int? timeSliderValue;
  int? unitsSliderValue;
  int? moneySliderValue;

  TimeUnitMoney(
      {super.key,
      required this.userId,
      required this.connectorIndex,
      required this.activeButton,
      this.timeSliderValue,
      this.unitsSliderValue,
      this.moneySliderValue});

  @override
  State<TimeUnitMoney> createState() => _TimeUnitMoneyState();
}

class _TimeUnitMoneyState extends State<TimeUnitMoney> {
  // startChargingCall(String userId,String idTag, String connectorNumber,String chargerSerialNumber,int amount,int minutes,double energyUnits,String requestedUnit,String modeOfCharging)async {
  //   try{
  //     final requestBody ={
  //       "userId" : userId,
  //       "idTag" : idTag,
  //       "connectorNumber" : connectorNumber,
  //       "chargerSerialNumber" : chargerSerialNumber,
  //       "amount": amount,
  //       "minutes": minutes,
  //       "energyUnits": energyUnits,
  //       "requestedUnit": requestedUnit,
  //       "modeOfCharging" : modeOfCharging
  //     };
  //
  //     final requestBodyJson = json.encode(requestBody);
  //     //print("sending this data : ${requestBodyJson.toString()}");
  //     final apiUrl = Uri.parse(
  //         '${Urls().baseUrl}8103/manageTransaction/startTransactionRequest');
  //
  //     final response = await http.post(apiUrl,headers: {
  //       'Content-Type': 'application/json'
  //     },body: requestBodyJson);
  //
  //     if (response.statusCode == 200){
  //       if(response.body.toString()!="exist"&&response.body.toString()!="unavailable") {
  //         final String TRNID = response.body.toString();
  //         //print("this is TRNID: ${TRNID}");
  //         Navigator.push(context, MaterialPageRoute(
  //             builder: (context) => StartChargingScreen(TRNID: response.body,)));
  //       }else{
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 content: Text('${response.body.toString()}'),
  //                 actions: [
  //                   ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text('OK'))
  //                 ],
  //               );
  //             });
  //       }
  //     }else{
  //       //print("200 not found...");
  //     }
  //   }catch(e){
  //     //print("Error : ${e}");
  //   }
  // }
  final storage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final customizeCharging = Provider.of<CustomizeProvider>(context);
    return Column(
      children: [
        const Text('We will take a value which you select at last.'),
        Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  width: 2, color: const Color.fromARGB(255, 146, 204, 81))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //Button for time slider button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: widget.activeButton == 1 ? 4 : 0,
                    backgroundColor: widget.activeButton == 1
                        ? const Color.fromARGB(255, 146, 208, 80)
                        : Colors.transparent, // Set the button color
                  ),
                  onPressed: () {
                    // setState(() {
                    widget.activeButton = 1;
                    widget.moneySliderValue = 0;
                    widget.unitsSliderValue = 0;
                    // });
                    customizeCharging.setIndex(widget.activeButton);
                  },
                  child: Text('Time',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.activeButton == 1
                              ? Colors.white
                              : const Color.fromARGB(255, 146, 208, 80)))),

              //button for unit slider button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: widget.activeButton == 2 ? 4 : 0,
                    backgroundColor: widget.activeButton == 2
                        ? const Color.fromARGB(255, 146, 208, 80)
                        : Colors.transparent, // Set the button color
                  ),
                  onPressed: () {
                    // setState(() {
                    widget.timeSliderValue = 0;
                    widget.activeButton = 2;
                    widget.moneySliderValue = 0;
                    // });
                    customizeCharging.setIndex(widget.activeButton);
                  },
                  child: Text(
                    'Units',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.activeButton == 2
                            ? Colors.white
                            : const Color.fromARGB(255, 146, 208, 80)),
                  )),

              //button for money slider button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: widget.activeButton == 3 ? 4 : 0,
                    backgroundColor: widget.activeButton == 3
                        ? const Color.fromARGB(255, 146, 208, 80)
                        : Colors.transparent, // Set the button color
                  ),
                  onPressed: () {
                    setState(() {
                      widget.activeButton = 3;
                      widget.timeSliderValue = 0;
                      widget.unitsSliderValue = 0;
                    });
                  },
                  child: Text(
                    'Money',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.activeButton == 3
                            ? Colors.white
                            : const Color.fromARGB(255, 146, 208, 80)),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: widget.activeButton == 1
              ? const Text(
                  "How long you will charge?",
                  style: TextStyle(
                    fontSize: 23,
                  ),
                )
              : widget.activeButton == 2
                  ? const Text(
                      "How long you will charge?",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    )
                  : const Text(
                      "How long you will charge?",
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    ),
        ),
        widget.activeButton == 1
            ?
            //Container for Time slider
            Container(
                height: Get.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Container for set limit text
                        Text(
                          'Set Limit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                          ),
                        ),
                        //silder
                        Column(
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor:
                                    const Color.fromARGB(255, 146, 204, 81),
                                // inactiveTrackColor:
                                // Colors.grey,
                                thumbColor:
                                    const Color.fromARGB(255, 146, 204, 81),
                                overlayColor:
                                    const Color.fromARGB(255, 146, 204, 81)
                                        .withOpacity(0.2),
                              ),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  valueIndicatorColor:
                                      const Color.fromARGB(255, 146, 204, 81),
                                  valueIndicatorTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: 360,
                                  divisions: 360,
                                  inactiveColor: Colors.grey,
                                  // const Color.fromARGB(
                                  //     255, 191, 235, 141),
                                  activeColor:
                                      const Color.fromARGB(255, 146, 204, 81),
                                  value: widget.timeSliderValue!.toDouble(),
                                  onChanged: (newValue) {
                                    widget.timeSliderValue = newValue.toInt();
                                    customizeCharging
                                        .setTime(widget.timeSliderValue);
                                  },
                                  label:
                                      '${widget.timeSliderValue!.toStringAsFixed(0)} min',
                                ),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("0 minutes"),
                                Text("360 minutes")
                              ],
                            ),
                          ],
                        ),
                        //container to show the selected value
                        Text(
                          '${widget.timeSliderValue} minutes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.06,
                              color: const Color.fromARGB(255, 146, 204, 81)),
                        ),
                      ]),
                ),
              )
            : widget.activeButton == 2
                ?
                //Container for Units slider
                Container(
                    height: Get.height * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //container for set limit text
                            Text(
                              'Set Limit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                            //slider
                            Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                        const Color.fromARGB(255, 146, 204, 81),
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor:
                                        const Color.fromARGB(255, 146, 204, 81),
                                    overlayColor:
                                        const Color.fromARGB(255, 146, 204, 81)
                                            .withOpacity(0.2),
                                  ),
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      valueIndicatorColor: const Color.fromARGB(
                                          255, 146, 204, 81),
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      inactiveColor: Colors.grey,
                                      // const Color
                                      //     .fromARGB(
                                      //     255,
                                      //     191,
                                      //     235,
                                      //     141),
                                      activeColor: const Color.fromARGB(
                                          255, 146, 204, 81),
                                      value:
                                          widget.unitsSliderValue!.toDouble(),
                                      onChanged: (newValue) {
                                        widget.unitsSliderValue =
                                            newValue.toInt();

                                        customizeCharging
                                            .setUnit(widget.unitsSliderValue);
                                      },
                                      label:
                                          '${widget.unitsSliderValue!.toStringAsFixed(0)} Units',
                                    ),
                                  ),
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("0 Units"),
                                    Text("100 Units")
                                  ],
                                ),
                              ],
                            ),

                            //container to show the selected value
                            Text(
                              '${widget.unitsSliderValue} Units',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  color:
                                      const Color.fromARGB(255, 146, 204, 81)),
                            ),
                          ]),
                    ),
                  )
                :
                //Container for Money slider
                Container(
                    height: Get.height * 0.25,
                    // margin: EdgeInsets.symmetric(
                    //     horizontal: MediaQuery.of(context)
                    //         .size
                    //         .width *
                    //         0.06),
                    // decoration: BoxDecoration(
                    //     color: const Color.fromARGB(
                    //         255, 146, 204, 81)
                    //         .withOpacity(0.2),
                    //     borderRadius:
                    //     BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //container for set limit text
                            Text(
                              'Set Limit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                            ),
                            //slider
                            Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                        const Color.fromARGB(255, 146, 204, 81),
                                    inactiveTrackColor: Colors.grey,
                                    thumbColor:
                                        const Color.fromARGB(255, 146, 204, 81),
                                    overlayColor:
                                        const Color.fromARGB(255, 146, 204, 81)
                                            .withOpacity(0.2),
                                  ),
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      valueIndicatorColor: const Color.fromARGB(
                                          255, 146, 204, 81),
                                      valueIndicatorTextStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Slider(
                                      min: 0,
                                      max: 1000,
                                      divisions: 1000,
                                      // inactiveColor:Colors.grey,
                                      // const Color
                                      //     .fromARGB(
                                      //     255,
                                      //     191,
                                      //     235,
                                      //     141),
                                      activeColor: const Color.fromARGB(
                                          255, 146, 204, 81),
                                      value:
                                          widget.moneySliderValue!.toDouble(),
                                      onChanged: (newValue) {
                                        widget.moneySliderValue =
                                            newValue.toInt();

                                        customizeCharging.setMoney(widget
                                            .moneySliderValue!
                                            .toDouble());
                                      },
                                      label:
                                          '₹ ${widget.moneySliderValue!.toStringAsFixed(0)}',
                                    ),
                                  ),
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [Text("₹ 0"), Text("₹ 1000")],
                                ),
                              ],
                            ),

                            //container to show the selected value
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  color: Color.fromARGB(255, 146, 204, 81),
                                ),
                                Text(
                                  '${widget.moneySliderValue}',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      color: const Color.fromARGB(
                                          255, 146, 204, 81)),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () async {
              String chargingMode;
              int time, unit;
              double money;
              if (widget.activeButton == 1) {
                time = customizeCharging.timeLimit;
                unit = 0;
                customizeCharging.setUnit(0);
                money = 0.0;
                customizeCharging.setMoney(0.0);
                chargingMode = "byTime";
                //print("by time : $time , $unit , $money");
                var start = StartChargingService(context);
                final userId = await storage.read(key: 'userId');
                start.startChargingApiCall(
                    "$userId",
                    "$userId",
                    widget.connectorIndex,
                    "VPEL",
                    time,
                    unit,
                    money,
                    chargingMode);
              } else if (widget.activeButton == 2) {
                time = 0;
                customizeCharging.setTime(0);
                unit = customizeCharging.unitLimit;
                customizeCharging.setMoney(0.0);
                money = 0.0;
                chargingMode = "byUnit";
                //print("by unit : $time , $unit , $money");
                var start = StartChargingService(context);
                final userId = await storage.read(key: 'userId');
                start.startChargingApiCall(
                    "$userId",
                    "$userId",
                    widget.connectorIndex,
                    "VPEL",
                    time,
                    unit,
                    money,
                    chargingMode);
              } else {
                time = 0;
                customizeCharging.setTime(0);
                unit = 0;
                customizeCharging.setUnit(0);
                money = customizeCharging.moneyLimit.toDouble();
                chargingMode = "byMoney";
                //print("by money : $time , $unit , $money");
                var start = StartChargingService(context);
                final userId = await storage.read(key: 'userId');
                start.startChargingApiCall(
                    "$userId",
                    "$userId",
                    widget.connectorIndex,
                    "VPEL",
                    time,
                    unit,
                    money,
                    chargingMode);
              }
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
