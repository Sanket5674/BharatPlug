// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:marquee/marquee.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcharge/models/chargerModel.dart';
import 'package:vcharge/services/DeleteMethod.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/services/PostMethod.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/view/homeScreen/widgets/bgMap.dart';
import 'package:vcharge/view/stationsSpecificDetails/widgets/timeUnitMoney.dart';
import '../../models/feedback_model.dart';
import '../../models/stationModel.dart';
import 'package:vcharge/view/stationsSpecificDetails/widgets/review_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../services/StartChargingService.dart';
import '../startChargingScreen/startChargingScreen.dart';

// ignore: must_be_immutable
class StationsSpecificDetails extends StatefulWidget {
  String stationId;
  String userId;
  final VoidCallback? isFavoriteadded;

  StationsSpecificDetails({
    required this.stationId,
    required this.userId,
    this.isFavoriteadded,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => StationsSpecificDetailsState();
}

class StationsSpecificDetailsState extends State<StationsSpecificDetails> {
  List<ChargerModel> chargerList = [];
  String? chargerId;
  String? stationId;
  String? connectorId;
  String? feedbackStationId;
  int userRating = 0;
  String? feedbackId;
  List<FeedbackModel> feedbackList = [];
  int activeButton = 1;
  int timeSliderValue = 0;
  int unitsSliderValue = 0;
  int moneySliderValue = 0;
  StationModel? stationDetails;
  int selected = -1;
  int position = -1;
  bool selectedButton = true;
  bool isFavorite = false;
  List<bool> isOpenList = [];
  final storage = const FlutterSecureStorage();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    stationId = widget.stationId;
    feedbackStationId = widget.stationId;
    getStationDetails();
    getChargerList();
    checkFavorite();
    _loadUserRating();
  }

  startChargingCall(
      String userId,
      String idTag,
      String connectorNumber,
      String chargerSerialNumber,
      int amount,
      int minutes,
      double energyUnits,
      String requestedUnit,
      String modeOfCharging,
      ) async {
    try {
      final requestBody = {
        "userId": userId,
        "idTag": idTag,
        "connectorNumber": connectorNumber,
        "chargerSerialNumber": chargerSerialNumber,
        "amount": amount,
        "minutes": minutes,
        "energyUnits": energyUnits,
        "requestedUnit": requestedUnit,
        "modeOfCharging": modeOfCharging
      };

      final requestBodyJson = json.encode(requestBody);
      final apiUrl = Uri.parse(
          '${Urls().transactionUrl}/manageTransaction/startTransactionRequest');

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        if (response.body != "exist" && response.body != "unavailable") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StartChargingScreen(TRNID: response.body),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(response.body.toString()),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      // ignore
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Future<List<FeedbackModel>> fetchFeedback() async {
    try {
      feedbackList.clear();
      final apiUrl = Uri.parse(
          '${Urls().feedbackUrl}/manageFeedback/getFeedbackByStationId?feedbackStationId=${widget.stationId}');

      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final List<FeedbackModel> feedbackList =
        jsonList.map((json) => FeedbackModel.fromJson(json)).toList();
        return feedbackList;
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      return feedbackList;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getStationDetails() async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().stationUrl}/manageStation/getStation?stationId=${widget.stationId}');
      setState(() {
        stationDetails = StationModel.fromJson(data);
      });
    } catch (e) {}
  }

  Future<void> getChargerList() async {
    try {
      chargerList.clear();
      var data = await GetMethod.getRequest(context,
          '${Urls().stationUrl}/manageCharger/getChargers?stationId=$stationId');
      if (data != null) {
        setState(() {
          for (int i = 0; i < data.length; i++) {
            chargerList.add(ChargerModel.fromJson(data[i]));
          }
          isOpenList = List.generate(data.length, (index) => false);
        });
      }
    } catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserRating() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int storedRating =
        prefs.getInt('userRating_${widget.stationId}_${userId}') ?? 0;
    setState(() {
      userRating = storedRating;
    });
  }

  MaterialColor getAvailabilityColor(String availabilityStatus) {
    switch (availabilityStatus.toLowerCase()) {
      case 'available':
        return Colors.green;
      case 'unavailable':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> checkFavorite() async {
    try {
      const storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getFavoritesByUserId?userId=$userId');
      if (data != null) {
        for (var fav in data) {
          if (widget.stationId == fav['stationId']) {
            setState(() => isFavorite = true);
            break;
          }
        }
      }
    } catch (e) {}
  }

  /// 🔧 Main Build
  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Station")),
        body: RefreshIndicator(
          key: refreshkey,
          onRefresh: () async {
            getStationDetails();
            getChargerList();
            checkFavorite();
            _loadUserRating();
            feedbackList = await fetchFeedback();
          },
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: stationDetails == null
                    ? Center(
                  child: LoadingAnimationWidget.waveDots(
                      color: Colors.green, size: 40),
                )
                    : Column(
                  children: [
                    // ... [UNCHANGED CODE ABOVE]

                    // ⚠️ FIXED BUTTON COLOR HERE:
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // ✅ FIXED
                      ),
                      child: const Text('Charge'),
                    ),

                    // ⚠️ FIX LOADING WIDGET NAMES:
                    LoadingAnimationWidget.progressiveDots( // ✅ FIXED spelling
                      color: Colors.green,
                      size: 40,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
