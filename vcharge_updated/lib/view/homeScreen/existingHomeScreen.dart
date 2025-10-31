import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:vcharge/models/allstationdatamodel.dart';
import 'package:vcharge/view/favouriteScreen/favouriteScreen.dart';
import 'package:vcharge/view/homeScreen/widgets/bgMap.dart';
import 'package:vcharge/view/homeScreen/widgets/filterPopUp.dart';
import 'package:vcharge/view/homeScreen/widgets/locationFinder.dart';
import 'package:vcharge/view/homeScreen/widgets/markerHints.dart';
import 'package:vcharge/view/homeScreen/widgets/searchBar/searchBar.dart';
import 'package:vcharge/view/homeScreen/widgets/sideBarDrawer.dart';
import 'package:vcharge/view/homeScreen/widgets/virtuosoLogo.dart';
import '../../models/stationModel.dart';
import '../startChargingScreen/startChargingScreen.dart';

// ignore: must_be_immutable
class ExistingHomeScreen extends StatefulWidget {
  String userId;

  ExistingHomeScreen({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => ExistingHomeScreenState();
}

class ExistingHomeScreenState extends State<ExistingHomeScreen> {
  var vehicleSelected;
  var showAvailableChargersOnly;
  var stationMode;
  var chargerType;
  var selectedConnectorType;
  final storage = const FlutterSecureStorage();
  List<AllStationDataModel> matchingStations = [];
  List<RequiredStationDetailsModel> listOfConnectorType = [];

  updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTrnId();
  }

  String? TRNID;

  getTrnId() async {
    TRNID = await storage.read(key: "TRNID");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void applyFilters(Map<String, dynamic> filters) {
    setState(() {
      ////print("this is selected value : ${filters['showAvailableChargersOnly']} ${filters['stationMode']} ${filters['selectedConnectorType']}");

      BgMapState.updateFilters(context, filters);

      ////printMatchingStations();
    });
  }

  // void //printMatchingStations() {
  //   //print('Matching Stations: $matchingStations');
  //   setState(() {});
  // }

  Widget build(BuildContext context) {
    getTrnId();
    return Scaffold(
      backgroundColor: Colors.transparent,
      drawer: SideBarDrawer(userId: widget.userId),
      body: Stack(
        children: [
          BgMap(
            userId: widget.userId,
            typesOfConnector: listOfConnectorType,
            vehicleSelected: vehicleSelected,
            showAvailableChargersOnly: showAvailableChargersOnly,
            stationMode: stationMode,
            selectedConnectorType: selectedConnectorType,
          ),
          SearchBarContainer(
            userId: widget.userId,
            callBack: updateState,
          ),

          // location finder
          Positioned(
            bottom: Get.height * 0.08,
            right: 0,
            child: LocationFinder(updateState: updateState),
          ),

          // Virtuoso logo
          Positioned(
            bottom: Get.height * 0.08,
            left: 0,
            child: VirtuosoLogo(),
          ),

          TRNID != null
              ? Positioned(
                  bottom: Get.height * 0.29,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartChargingScreen(
                                    TRNID: TRNID.toString(),
                                  )));
                    },
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        elevation: 1,
                        child: LiquidCircularProgressIndicator(
                          value: 70 / 100,
                          // Defaults to 0.5.
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.green),
                          backgroundColor: Colors.transparent,
                          borderColor: Colors.green,
                          borderWidth: 0.5,
                          direction: Axis.vertical,
                          center: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.electric_bolt,
                                  color: Colors.yellow,
                                  size: 40,
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),

          //Hint question Mark
          Positioned(
            bottom: Get.height * 0.15,
            right: 0,
            child: const MarkerHints(),
          ),

          Positioned(
            bottom: Get.height * 0.23,
            right: 0,
            child: Semantics(
              label: "fav0riteButton",
              child: GestureDetector(
                key: const Key('favoriteButton'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FavoriteScreen(userId: widget.userId),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: const EdgeInsets.only(right: 13),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // filter
          Positioned(
            bottom: Get.height * 0.28,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final selectedValues = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return FilterPopUp(
                      list: listOfConnectorType,
                      userId: widget.userId,
                    );
                  },
                );

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
                    if (selectedValues.containsKey('chargerType')) {
                      chargerType = selectedValues['chargerType'];
                    }
                    if (selectedValues.containsKey('selectedConnectorType')) {
                      selectedConnectorType =
                          selectedValues['selectedConnectorType'];
                    }
                  });
                  BgMapState.updateFilters(context, selectedValues);
                }
              },
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                margin: const EdgeInsets.only(right: 13, bottom: 10),
                child: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.filter_alt_sharp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
