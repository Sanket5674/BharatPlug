import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';

import '../../../services/urls.dart';

class ManufacturerSelectionWidget extends StatefulWidget {
  final String userId;
  final String selectedVehicleType;
  final Function(String?) onSelectManufacturer;

  ManufacturerSelectionWidget({
    required this.userId,
    required this.selectedVehicleType,
    required this.onSelectManufacturer,
  });

  @override
  _ManufacturerSelectionWidgetState createState() =>
      _ManufacturerSelectionWidgetState();
}

class _ManufacturerSelectionWidgetState
    extends State<ManufacturerSelectionWidget> {
  late List<String> displayedManufacturers = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchManufacturers().then((manufacturers) {
      setState(() {
        displayedManufacturers = manufacturers;
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

  Future<List<String>> fetchManufacturers() async {
    try {
      final apiUrl =
          '${Urls().masterUrl}/manageVehicle/getAllBrandNameByVehicleType?vehicleType=${widget.selectedVehicleType}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0] is String) {
          return List<String>.from(data);
        }
      }

      throw Exception('Failed to load manufacturers');
    } catch (e) {
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return displayedManufacturers;
  }

  void _selectCarModel(BuildContext context, String manufacturer) async {
    widget.onSelectManufacturer(manufacturer);
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
                      labelText: 'Search Manufacturers',
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
                      : displayedManufacturers.isEmpty
                          ? const Center(
                              child: Text(
                                "Something Went Wrong !",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          : ListView.builder(
                              itemCount: displayedManufacturers.length,
                              itemBuilder: (context, index) {
                                final manufacturer =
                                    displayedManufacturers[index];
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
