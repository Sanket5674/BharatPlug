import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';

import 'package:vcharge/models/addVehicleModel.dart';

import '../../../services/urls.dart';

class CarClassSelectionBottomSheet extends StatefulWidget {
  final String selectedManufacturer;
  final String userId;
  final String selectedCarModel;
  final Function(Map<String, String?>) onSelectCarClass;

  CarClassSelectionBottomSheet({
    required this.userId,
    required this.selectedManufacturer,
    required this.selectedCarModel,
    required this.onSelectCarClass,
  });

  @override
  _CarClassSelectionBottomSheetState createState() =>
      _CarClassSelectionBottomSheetState();
}

class _CarClassSelectionBottomSheetState
    extends State<CarClassSelectionBottomSheet> {
  List<AddVehicleModel> carClass = [];
  TextEditingController searchController = TextEditingController();
  AddVehicleModel? selectedClass;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchVehicleClasses().then((classes) {
      setState(() {
        carClass = classes;
      });
      Future.delayed(const Duration(seconds: 10), () {
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
      });
    });
  }

  Future<List<AddVehicleModel>> fetchVehicleClasses() async {
    try {
      final apiUrl =
          '${Urls().masterUrl}/manageVehicle/getVehicleClass?vehicleBrandName=${widget.selectedManufacturer}&vehicleModelName=${widget.selectedCarModel}';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is Map) {
          final List<AddVehicleModel> classes = data
              .map((classJson) => AddVehicleModel.fromJson(classJson))
              .toList();
          return classes;
        }
      }
    } catch (e) {
      //////print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    throw Exception('Failed to load vehicle classes');
  }

  void _selectCarClass(AddVehicleModel vehicleClass) async {
    widget.onSelectCarClass({
      'userId': widget.userId,
      'selectedManufacturer': vehicleClass.vehicleBrandName,
      'selectedCarModel': vehicleClass.vehicleModelName,
      'vehicleId': vehicleClass.vehicleId,
      'vehicleClass': vehicleClass.vehicleClass,
      'connectorType': vehicleClass.vehicleConnectorType,
      'batteryCapacity': vehicleClass.vehicleBatteryCapacity,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Vehicle Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.all(16),
            elevation: 5,
            color: const Color.fromARGB(255, 246, 249, 252),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search Models',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 450,
                  child: isLoading
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: Colors.green, size: 40),
                        )
                      : carClass.isEmpty
                          ? const Center(
                              child: Text(
                                "Something Went Wrong !",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: carClass.length,
                              itemBuilder: (context, index) {
                                final vehicleClass = carClass[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  child: ListTile(
                                      title:
                                          Text(vehicleClass.vehicleClass ?? ''),
                                      onTap: () {
                                        setState(() {
                                          selectedClass = vehicleClass;
                                        });

                                        _selectCarClass(selectedClass!);
                                      }),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
