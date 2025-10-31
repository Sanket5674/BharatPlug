// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:vcharge/view/homeScreen/widgets/filterPopUp.dart';
import 'package:vcharge/view/listOfStations/widgets/losSearchingWidget.dart';

import '../../../models/stationModel.dart';

typedef MapCallback = void Function(Map<String, dynamic> val);

class SearchBarofLOS extends StatefulWidget {
  String userId;
  final MapCallback callback;

  SearchBarofLOS({required this.userId, required this.callback, super.key});

  @override
  State<StatefulWidget> createState() => SearchBarofLOSState();
}

class SearchBarofLOSState extends State<SearchBarofLOS> {
  List<RequiredStationDetailsModel> listOfConnectorType = [];
  var vehicleSelected;
  var showAvailableChargersOnly;
  var stationMode;
  var selectedConnectorType;
  var availableToggleButton = false;
  var privateToggleButton = false;

  @override
  Widget build(BuildContext context) {
    // material object -
    return Scaffold(
      body: Container(
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
          readOnly: true,

          // function for opeing the searching widget
          onTap: () {
            showSearch(
                context: context, delegate: losSearchingWidget(widget.userId));
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search Stations",
              prefixIcon: IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: losSearchingWidget(widget.userId));
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    size: MediaQuery.of(context).size.width * 0.07,
                  )),
              suffixIcon: IconButton(
                  color: Colors.green,
                  onPressed: () async {
                    final selectedValues = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        builder: (BuildContext context) {
                          return FilterPopUp(
                            list: listOfConnectorType,
                            userId: widget.userId,
                          );
                        });

                    if (selectedValues != null) {
                      setState(() {
                        if (selectedValues
                            .containsKey('showAvailableChargersOnly')) {
                          showAvailableChargersOnly =
                              selectedValues['showAvailableChargersOnly'];
                        }
                        if (selectedValues.containsKey('stationMode')) {
                          stationMode = selectedValues['stationMode'];
                        }
                        if (selectedValues
                            .containsKey('selectedConnectorType')) {
                          selectedConnectorType =
                              selectedValues['selectedConnectorType'];
                        }
                      });
                      widget.callback(selectedValues);
                      // ignore: use_build_context_synchronously
                    }
                  },
                  icon: Icon(
                    Icons.filter_alt,
                    color: Colors.green,
                    size: MediaQuery.of(context).size.width * 0.07,
                  ))),
        ),
      ),
    );
  }
}
