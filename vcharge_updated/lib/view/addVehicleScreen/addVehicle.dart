// ignore_for_file: prefer_typing_uninitialized_variables, avoid_//print

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/view/Announcement/Announcement.dart';
//import 'package:vcharge/view/addVehicleScreen/widgets/ClassSelectionScreen.dart';
import 'package:vcharge/view/addVehicleScreen/widgets/ModelSelectionScreen.dart';
import 'package:vcharge/view/addVehicleScreen/widgets/classSelectionBottomSheet.dart';
import 'package:vcharge/view/addVehicleScreen/widgets/ManufacturerSelection.dart';
import 'package:http/http.dart' as http;

import '../connectivity_service.dart';

// ignore: must_be_immutable
class AddVehicleScreen extends StatefulWidget {
  final String userId;
  final String? selectedManufacturer;
  final String? selectedCarModel;
  final String? connectorType;
  final String? batteryCapacity;
  final String? vehicleClass;
  final String? selectedVehicleType;
  String? vehicleId;
  final VoidCallback? onVehicleAdding;

  AddVehicleScreen(
      {super.key,
      required this.userId,
      this.selectedManufacturer,
      this.selectedCarModel,
      this.connectorType,
      this.batteryCapacity,
      this.vehicleId,
      this.vehicleClass,
      this.selectedVehicleType,
      this.onVehicleAdding});

  @override
  State<StatefulWidget> createState() => AddVehicleScreenState();
}

class AddVehicleScreenState extends State<AddVehicleScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final formKey = GlobalKey<FormState>();
  String? registrationNumber;
  var vehicleType = ['two', 'three', 'four'];
  var selectedVehicleType;
  var vehicleTypeSelectBool = [false, false, false];
  var selectedManufacturer;
  var selectedCarModel;
  var selectedCarClass;
  var connectorType;
  var batteryCapacity;
  var regNoController = TextEditingController();
  var nickNameController = TextEditingController();
  bool isVehicleIdAvailable = false;
  bool showVehicleTypeError = false;
  bool showVehicleModelerror = false;
  bool showVehicleClasserror = false;
  bool showVehicleDetailsError = false;
  bool isVehicleTypeSelected() {
    return selectedVehicleType != null;
  }

  void navigateToMyVehicleScreen() {
    Navigator.of(context).pop();
  }

  void _showManufacturerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ManufacturerSelectionWidget(
          userId: widget.userId,
          selectedVehicleType: mapVehicleType(selectedVehicleType),
          onSelectManufacturer: (manufacturer) {
            setState(() {
              selectedManufacturer = manufacturer;
              selectedCarModel = null;
              selectedCarClass = null;
              connectorType = null;
              batteryCapacity = null;
            });
          },
        );
      },
    );
    if (selectedManufacturer != null) {}
  }

  void _showModelBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CarModelSelectionBottomSheet(
          userId: widget.userId,
          selectedVehicleType: mapVehicleType(selectedVehicleType),
          selectedManufacturer: selectedManufacturer,
          onSelectCarModel: (model) {
            setState(() {
              selectedCarModel = model;
              selectedCarClass = null;
              connectorType = null;
              batteryCapacity = null;
            });
          },
        );
      },
    );
    if (selectedCarModel != null) {}
  }

  void _showClassBottomSheet(BuildContext context) async {
    final classes = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CarClassSelectionBottomSheet(
          userId: widget.userId,
          selectedManufacturer: selectedManufacturer,
          selectedCarModel: selectedCarModel,
          onSelectCarClass: (Map<String, String?> classes) {
            setState(() {
              selectedCarClass = classes['vehicleClass'];
              connectorType = classes['connectorType'];
              batteryCapacity = classes['batteryCapacity'];
              widget.vehicleId = classes['vehicleId'];
              onClassChanged(selectedCarClass);
            });
          },
        );
      },
    );

    if (classes != null) {}
  }

  void onClassChanged(newClass) {
    if (newClass != selectedCarClass) {
      setState(() {
        connectorType = null;
        batteryCapacity = null;
      });
    }
  }

  String mapVehicleType(int value) {
    if (value == 0) {
      return '2 Wheeler';
    } else if (value == 1) {
      return '4 Wheeler';
    } else if (value == 2) {
      return '3 Wheeler';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    if (widget.vehicleId != null) {
      isVehicleIdAvailable = true;
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // ignore: use_build_context_synchronously
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  bool areDetailsSelected() {
    return selectedVehicleType != null &&
        selectedManufacturer != null &&
        selectedCarModel != null &&
        selectedCarClass != null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _saveVehicle() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    final apiUrl =
        '${Urls().userUrl}/manageUser/addVehicles?userId=$userId&vehicleId=${widget.vehicleId}';
    final response = await http.post(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vehicle Added Successfully'),
        ),
      );
      navigateToMyVehicleScreen();
      widget.onVehicleAdding?.call();

      setState(() {
        selectedVehicleType = null;
        selectedManufacturer = null;
        selectedCarModel = null;
        selectedCarClass = null;
        connectorType = null;
        batteryCapacity = null;
        widget.vehicleId = null;
      });
    } else {
      //print('Failed to add vehicle. Status code: ${response.statusCode}');
    }
  }

  void _onVehicleTypeChanged(newVehicleType) {
    setState(() {
      selectedVehicleType = newVehicleType;
      selectedManufacturer = null;
      selectedCarModel = null;
      selectedCarClass = null;
      connectorType = null;
      batteryCapacity = null;
      widget.vehicleId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnnouncementBox(positionName: 'underMaintenance'),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // vehicle type heading
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        'Vehicle Type',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //check box for two wheeler
                        Row(
                          children: [
                            Radio(
                                groupValue: selectedVehicleType,
                                value: 0,
                                onChanged: (value) {
                                  _onVehicleTypeChanged(value);
                                }),
                            const Icon(
                              Icons.electric_moped_rounded,
                              color: Colors.green,
                            ),
                          ],
                        ),

                        //check box for four wheeler
                        Row(
                          children: [
                            Radio(
                                groupValue: selectedVehicleType,
                                value: 1,
                                onChanged: (value) {
                                  _onVehicleTypeChanged(value);
                                }),
                            const Icon(
                              Icons.electric_car,
                              color: Colors.green,
                            )
                          ],
                        ),

                        //check box for three wheeler
                        Row(
                          children: [
                            Radio(
                                groupValue: selectedVehicleType,
                                value: 2,
                                onChanged: (value) {
                                  _onVehicleTypeChanged(value);
                                }),
                            const Icon(
                              Icons.electric_rickshaw,
                              color: Colors.green,
                            )
                          ],
                        ),
                      ],
                    ),

                    Visibility(
                      visible: showVehicleTypeError,
                      child: const Text(
                        'Please select a vehicle type',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 1,
                  height: 15,
                ),

                //heading text of vehicle name
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    'Vehicle Manufacturer',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),

                const SizedBox(
                  width: 1,
                  height: 5,
                ),

                Card(
                  elevation: 5.0,
                  color: const Color.fromARGB(255, 246, 249, 252),
                  child: InkWell(
                    onTap: () {
                      if (isVehicleTypeSelected()) {
                        _showManufacturerBottomSheet(context);

                        showVehicleTypeError = false;
                      } else {
                        setState(() {
                          showVehicleTypeError = true;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                      child: ListTile(
                        title: Text(
                          selectedManufacturer ?? 'Select Manufacturer',
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //heading text of vehicle Model name
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    'Vehicle Model',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),

                const SizedBox(
                  width: 1,
                  height: 5,
                ),

                Card(
                  elevation: 5.0,
                  color: const Color.fromARGB(255, 246, 249, 252),
                  child: InkWell(
                    onTap: () {
                      if (selectedManufacturer != null) {
                        _showModelBottomSheet(context);
                        showVehicleModelerror = false;
                      } else {
                        setState(() {
                          showVehicleModelerror = true;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                      child: ListTile(
                        title: Text(
                          selectedCarModel ?? 'Select Model',
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showVehicleModelerror,
                  child: const Text(
                    'Please select Manufacturer First',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //heading text of vehicle Class name
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    'Vehicle Class',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),

                const SizedBox(
                  width: 1,
                  height: 5,
                ),

                Card(
                  elevation: 5.0,
                  color: const Color.fromARGB(255, 246, 249, 252),
                  child: InkWell(
                    onTap: () {
                      if (isVehicleTypeSelected() &&
                          selectedManufacturer != null &&
                          selectedCarModel != null) {
                        _showClassBottomSheet(context);
                        showVehicleClasserror = false;
                      } else {
                        setState(() {
                          showVehicleClasserror = true;
                        });
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                      child: ListTile(
                        title: Text(
                          selectedCarClass ?? 'Select Class',
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Visibility(
                  visible: showVehicleClasserror,
                  child: const Text(
                    'Please select Vehicle Model',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                if (connectorType != null || batteryCapacity != null)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: const Color.fromARGB(255, 246, 249, 252),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Row for connector type
                          if (connectorType != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Connector type',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        connectorType ?? " ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          if (batteryCapacity != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Battery Capacity',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        batteryCapacity ?? " ",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(
                  height: 80,
                ),

                Visibility(
                  visible: showVehicleDetailsError,
                  child: const Center(
                    child: Text(
                      'Please select vehicle Details First',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          if (!areDetailsSelected()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please first select vehicle details.'),
              ),
            );

            return;
          }
          _saveVehicle();
        },
        label: const Text(
          'Save',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
    );
  }
}
