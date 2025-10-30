import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../models/addVehicleModel.dart';
import '../../../models/stationModel.dart';
import '../../../services/GetMethod.dart';
import '../../../services/urls.dart';

// ignore: must_be_immutable
class FilterPopUp extends StatefulWidget {
  final String userId;
  final List<RequiredStationDetailsModel> list;

  FilterPopUp({required this.list, required this.userId, Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => FilterPopUpState();
}

class FilterPopUpState extends State<FilterPopUp> {
  String? selectedConnectorType;
  bool? reset;
  var showAvailableChargersOnly = true;
  bool? privateStationButton = false;
  bool? ACDCButton = false;
  String? chargerMode = 'AC';
  List<AddVehicleModel> vehicleList = [];
  AddVehicleModel? vehicleSelected;
  String? stationMode = "Public";
  var connectors = [];
  // var connectors = ["Type2", "CHAdeMO","Type A", "Type1"];
  late List<String?> selectedConnector;

  @override
  void initState() {
    super.initState();
    fetchVehicleData();
    getTypeListFromTypes(chargerMode);
    vehicleSelected = vehicleList.length == 0
        ? null
        : reset != null
            ? vehicleList[0]
            : null;
    selectedConnectorType = vehicleList.length == 0
        ? null
        : reset != null
            ? vehicleList[0].vehicleAdaptorType
            : null;
  }

  getTypeListFromTypes(String? chargerType) {
    connectors.clear();
    List data = [];
    for (int j = 0; j < widget.list.length; j++) {
      for (int k = 0; k < widget.list[j].chargers!.length; k++) {
        for (int p = 0;
            p < widget.list[j].chargers![k].connectors!.length;
            p++) {
          //print("${widget.list[j].chargers![k].connectors![p].connectorType}");
          if (null == chargerType) {
            data.add(widget.list[j].chargers![k].connectors![p].connectorType!);
          } else if (widget.list[j].chargers![k].chargerType == chargerType) {
            data.add(widget.list[j].chargers![k].connectors![p].connectorType!);
          }
        }
      }
    }

    data.forEach((element) {
      if (!connectors.contains(element)) {
        setState(() {
          connectors.add(element);
        });
      }
    });
    //print(connectors);
    selectedConnector = List.filled(connectors.length, null);
  }

  Future<void> fetchVehicleData() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getVehicleByUserId?userId=$userId');
      setState(() {
        if (data != null) {
          vehicleList = List<AddVehicleModel>.from(
              data.map((model) => AddVehicleModel.fromJson(model)));
        }
      });
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  Future<void> showConnectorConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text(
              'Do you want to select a connector and deselect the vehicle?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  vehicleSelected = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("connectors : $connectors");
    //print("selectedConnector : $selectedConnector");
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          width: double.maxFinite,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                //Title
                Text(
                  'Filter',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: SizedBox(
            height: 500,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            'Vehicle',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: DropdownButton(
                            value: vehicleSelected != null
                                ? vehicleSelected
                                : vehicleList.length == 0
                                    ? null
                                    : reset == null
                                        ? vehicleSelected = vehicleList[0]
                                        : null,
                            items: vehicleList.map((vehicle) {
                              return DropdownMenuItem(
                                value: vehicle,
                                child: Text(
                                  '${vehicle.vehicleBrandName} ${vehicle.vehicleModelName} ${vehicle.vehicleClass}',
                                  style: TextStyle(
                                    fontWeight: vehicleSelected == vehicle
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                            hint: const Text("Select vehicle"),
                            underline: Container(),
                            onChanged: (value) {
                              setState(() {
                                vehicleSelected = value;
                                selectedConnectorType =
                                    value?.vehicleAdaptorType;
                              });
                            },
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            isExpanded: true,
                            isDense: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Access Type',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  privateStationButton = false;
                                  stationMode = 'Public';
                                });
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                backgroundColor: privateStationButton == null
                                    ? Colors.white
                                    : !privateStationButton!
                                        ? Colors.green
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                side: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              child: const Text(
                                'Public',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  privateStationButton = true;
                                  stationMode = 'Private';
                                });
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                backgroundColor: privateStationButton == null
                                    ? Colors.white
                                    : privateStationButton!
                                        ? Colors.green
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                side: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              child: const Text(
                                'Private',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.03,
                        right: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Show Available Charger Only',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          Switch(
                            value: showAvailableChargersOnly,
                            onChanged: (newValue) {
                              setState(() {
                                showAvailableChargersOnly = newValue;
                              });
                            },
                            activeTrackColor: Colors.green,
                            activeColor:
                                const Color.fromARGB(255, 244, 244, 244),
                          )
                        ]),
                  ),
                ),

                Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Charger Type',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      ACDCButton = false;
                                      chargerMode = 'AC';
                                      getTypeListFromTypes(chargerMode);
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    backgroundColor: ACDCButton == null
                                        ? Colors.white
                                        : !ACDCButton!
                                            ? Colors.green
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                  child: const Text(
                                    'AC',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      ACDCButton = true;
                                      chargerMode = 'DC';
                                      getTypeListFromTypes(chargerMode);
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40),
                                    backgroundColor: ACDCButton == null
                                        ? Colors.white
                                        : ACDCButton!
                                            ? Colors.green
                                            : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    side: const BorderSide(
                                      color: Colors.green,
                                    ),
                                  ),
                                  child: const Text(
                                    'DC',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ])),
                //Container for Connector Type
                connectors.length > 0
                    ? Container(
                        width: double.maxFinite,
                        color: const Color.fromARGB(40, 131, 199, 85),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            'Connector Type',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    : Container(),
                const SizedBox(
                  width: 1,
                  height: 3,
                ),
                connectors.length > 0
                    ? ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: connectors.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 130, 199, 85),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(connectors[index]),
                                  Checkbox(
                                    value: connectors.length == 0
                                        ? false
                                        : selectedConnector[index] != null ||
                                            connectors[index] ==
                                                selectedConnectorType,
                                    onChanged: (value) {
                                      setState(() {
                                        //print("this is value : $value");
                                        selectedConnector[index] =
                                            value! ? connectors[index] : null;
                                        if (value) {
                                          if (vehicleSelected != null) {
                                            showConnectorConfirmationDialog(
                                                context);
                                          } else {
                                            selectedConnectorType =
                                                connectors[index];
                                          }
                                        } else {
                                          selectedConnectorType = null;
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  setState(() {
                    reset = true;
                    vehicleSelected = null;
                    showAvailableChargersOnly = false;
                    privateStationButton = null;
                    stationMode = null;
                    ACDCButton = null;
                    chargerMode = null;
                    getTypeListFromTypes(null);
                    selectedConnectorType = null;
                    selectedConnector = List.filled(connectors.length, null);
                  });
                  //print("test : $selectedConnector");
                },
                child:
                    const Text('Reset', style: TextStyle(color: Colors.black)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                onPressed: () {
                  List types = [];
                  selectedConnector.forEach((element) {
                    if (element != null) {
                      types.add(element);
                    }
                  });

                  final selectedValues = {
                    'showAvailableChargersOnly':
                        showAvailableChargersOnly ? 'Available' : null,
                    'stationMode': stationMode,
                    'chargerType': chargerMode,
                    'selectedConnectorType': types.length == 0 ? null : types,
                  };
                  Navigator.pop(context, selectedValues);
                },
                child:
                    const Text('Apply', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
