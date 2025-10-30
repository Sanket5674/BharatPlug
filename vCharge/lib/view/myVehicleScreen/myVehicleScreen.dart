// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
//import 'package:get/get.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/view/addVehicleScreen/addVehicle.dart';
import 'package:vcharge/view/myVehicleScreen/widgets/showVehilcleDetailsPopup.dart';

import '../../models/addVehicleModel.dart';
import '../connectivity_service.dart';

// ignore: must_be_immutable
class MyVehicleScreen extends StatefulWidget {
  String userId;
  MyVehicleScreen({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => MyVehicleScreenState();
}

class MyVehicleScreenState extends State<MyVehicleScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();

  List<AddVehicleModel> vehicleList = [];
  bool vehicleAPIExecuted = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getVehicleData();
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getVehicleData() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getVehicleByUserId?userId=$userId');
      vehicleList.clear();
      setState(() {
        if (data != null || data.length > 0) {
          for (int i = 0; i < data.length; i++) {
            vehicleList.add(AddVehicleModel.fromJson(data[i]));
          }
        } else {
          vehicleAPIExecuted = true;
        }
      });
    } catch (e) {
      vehicleAPIExecuted = true;
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getVehicleData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicle'),
      ),
      body: isLoading
          ? Center(
              child:
                  LoadingAnimationWidget.inkDrop(color: Colors.green, size: 40),
            )
          : vehicleList.isEmpty
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ))
              : ListView.builder(
                  itemCount: vehicleList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ShowVehicleDetailsPopup(
                                  vehicleDetails: vehicleList[index],
                                  onDelete: (deletedVehicle) {
                                    setState(() {
                                      vehicleList.remove(deletedVehicle);
                                    });
                                  });
                            });
                      },
                      child: Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 246, 249, 252),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Container for Car Image
                            Expanded(
                              flex: 2,
                              child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: vehicleList[index].vehicleType ==
                                          "2 Wheeler"
                                      ? Image.asset(
                                          "assets/images/2wheeler.png")
                                      : vehicleList[index].vehicleType ==
                                              "3 Wheeler"
                                          ? Image.asset(
                                              "assets/images/3wheeler.png",
                                            )
                                          : Image.asset(
                                              'assets/images/4wheeler.png')),
                            ),

                            // Container for Car Details
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // text car nick name
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, bottom: 5),
                                      child: Text(
                                        ' ${vehicleList[index].vehicleModelName}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, bottom: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${vehicleList[index].vehicleBrandName} ${vehicleList[index].vehicleModelName} ${vehicleList[index].vehicleClass} ',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Container for vehicle adaptor type
                                    if (vehicleList[index]
                                            .vehicleConnectorType !=
                                        null)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 3),
                                        child: Text(
                                          'Connector Type: ${vehicleList[index].vehicleConnectorType},',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),

                                    //Container for vehicle battery capacity
                                    if (vehicleList[index]
                                            .vehicleBatteryCapacity !=
                                        null)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 3),
                                        child: Text(
                                          'Battery Capacity: ${vehicleList[index].vehicleBatteryCapacity}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddVehicleScreen(
                      userId: widget.userId,
                      onVehicleAdding: getVehicleData,
                    )),
          );
        },
        label: const Text(
          'Add Vehicle',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
