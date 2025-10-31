import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';

import '../../../services/urls.dart';

class CarModelSelectionBottomSheet extends StatefulWidget {
  final String selectedManufacturer;
  final String userId;
  final String selectedVehicleType;
  final Function(String?) onSelectCarModel;

  CarModelSelectionBottomSheet({
    required this.userId,
    required this.selectedManufacturer,
    required this.selectedVehicleType,
    required this.onSelectCarModel,
  });

  @override
  _CarModelSelectionBottomSheetState createState() =>
      _CarModelSelectionBottomSheetState();
}

class _CarModelSelectionBottomSheetState
    extends State<CarModelSelectionBottomSheet> {
  List<String> carModels = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchCarModels().then((models) {
      setState(() {
        carModels = models;
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

  Future<List<String>> fetchCarModels() async {
    try {
      final apiUrl =
          '${Urls().masterUrl}/manageVehicle/getModelNameByBrandName?vehicleBrandName=${widget.selectedManufacturer}&vehicleType=${widget.selectedVehicleType}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0] is String) {
          return List<String>.from(data);
        }
      }
    } catch (e) {
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    throw Exception('Failed to load car models');
  }

  void _selectCarModel(BuildContext context, String model) async {
    widget.onSelectCarModel(model);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Vehicle Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
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
                Container(
                  height: 450,
                  child: isLoading
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: Colors.green, size: 40),
                        )
                      : carModels.isEmpty
                          ? const Center(
                              child: Text(
                                "Something Went Wrong !",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: carModels.length,
                              itemBuilder: (context, index) {
                                final manufacturer = carModels[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 16),
                                  child: ListTile(
                                    title: Text(manufacturer),
                                    onTap: () {
                                      _selectCarModel(context, manufacturer);
                                    },
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
