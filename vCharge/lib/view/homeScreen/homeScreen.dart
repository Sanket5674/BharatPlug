import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/view/homeScreen/existingHomeScreen.dart';
import 'package:vcharge/view/listOfStations/listOfStations.dart';
import 'package:vcharge/view/qrScanner.dart/scanner.dart';

import '../../services/notificationService.dart';
import '../Security/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  final Login? login;
  const HomeScreen({Key? key, this.login}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class Login {
  final String username;
  final String password;

  Login(this.username, this.password);
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  //this the user ID of the current user who is logged in
  static String userId = "";
  final storage = FlutterSecureStorage();
  getUserId() async {
    userId = (await storage.read(key: 'userId')) ?? '';
    TRNID = await storage.read(key: "TRNID");
    //print("this is userId: $userId");
  }

  var vehicleSelected;
  var showAvailableChargersOnly;
  var stationMode;
  var chargerType;
  var selectedConnectorType;
  List<RequiredStationDetailsModel> listOfConnectorType = [];

  String? TRNID;

  @override
  void initState() {
    getUserId();
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  NotificationService notificationService = NotificationService();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        //print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        //print("app in inactive");
        break;
      case AppLifecycleState.paused:
        if (TRNID != null) {
          notificationService.initializeNotification();
          notificationService.sendNotification(
              context,
              "Bharat Plug is charging your vehicle...",
              "thanks for connect us");
        }
        //print("app in paused");
        break;
      case AppLifecycleState.detached:
        //print("app in detached");
        break;
      case AppLifecycleState.hidden:
        //print("app in hidden");
        break;
    }
  }

  int selectedIndex = 1;

  final GlobalKey<CurvedNavigationBarState> bottomNavBarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
// screens
    List<dynamic> screens = [
      Semantics(
          label: "listOfStationPage",
          value: 'listOfStationPage',
          child: ListOfStations(
            userId: userId,
          )),
      Semantics(
        label: "homePage",
        value: "homePage",
        child: ExistingHomeScreen(
          userId: userId,
        ),
      ),
      Semantics(
          label: "scannerPage",
          value: "scannerPage",
          child: QRScannerWidget(
            userId: userId,
          )),
    ];

// bottom bar icons
    final items = <Widget>[
      Icon(Icons.list,
          size: 30, color: selectedIndex == 0 ? Colors.white : Colors.white),
      Icon(Icons.home,
          size: 30, color: selectedIndex == 1 ? Colors.white : Colors.white),
      Icon(Icons.qr_code_scanner,
          size: 30, color: selectedIndex == 2 ? Colors.white : Colors.white),
    ];

    return WillPopScope(
        onWillPop: () async {
          if (selectedIndex != 1) {
            setState(() {
              selectedIndex = 1;
            });
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              UpgradeAlert(child: screens[selectedIndex]),
              Align(
                alignment: Alignment.bottomCenter,
                child: CurvedNavigationBar(
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: Colors.green,
                    key: bottomNavBarKey,
                    animationCurve: Curves.easeInOut,
                    backgroundColor: Colors.transparent,
                    buttonBackgroundColor: Colors.green,
                    animationDuration: const Duration(milliseconds: 300),
                    items: items,
                    index: selectedIndex,
                    onTap: (index) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      setState(() {
                        selectedIndex = index;
                      });
                    }),
              ),
            ],
          ),
        ));
  }
}
