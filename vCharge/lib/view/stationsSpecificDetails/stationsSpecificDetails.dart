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

  StationsSpecificDetails(
      {required this.stationId,
      required this.userId,
      this.isFavoriteadded,
      super.key});

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
      String modeOfCharging) async {
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

      final response = await http.post(apiUrl,
          headers: {'Content-Type': 'application/json'}, body: requestBodyJson);

      if (response.statusCode == 200) {
        if (response.body.toString() != "exist" &&
            response.body.toString() != "unavailable") {
          //print("this is TRNID: ${TRNID}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StartChargingScreen(
                        TRNID: response.body,
                      )));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(response.body.toString()),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'))
                  ],
                );
              });
        }
      } else {}
    } catch (e) {
      //print("Error : $e");
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<FeedbackModel>> fetchFeedback() async {
    try {
      feedbackList.clear();
      final apiUrl = Uri.parse(
          '${Urls().feedbackUrl}/manageFeedback/getFeedbackByStationId?feedbackStationId=${widget.stationId}');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        //print("this is data : $jsonList");
        final List<FeedbackModel> feedbackList =
            jsonList.map((json) => FeedbackModel.fromJson(json)).toList();
        return feedbackList;
      } else {
        throw Exception('Failed to load feedback');
      }
    } catch (e) {
      //print(e);
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
      //print(widget.stationId);
      setState(() {
        stationDetails = StationModel.fromJson(data);
        //print(stationDetails);
      });
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  Future<void> getChargerList() async {
    try {
      chargerList.clear();
      var data = await GetMethod.getRequest(context,
          '${Urls().stationUrl}/manageCharger/getChargers?stationId=$stationId ');
      if (data != null) {
        setState(() {
          for (int i = 0; i < data.length; i++) {
            chargerList.add(ChargerModel.fromJson(data[i]));
          }
          isOpenList.clear();
          isOpenList = List.generate(data.length, (index) => false);
        });
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    } finally {
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
    //print("Stored user Rating is:$storedRating");
    setState(() {
      userRating = storedRating;
    });
  }

  MaterialColor getAvailabilityColor(String availabilityStatus) {
    if (availabilityStatus.toLowerCase() == 'available') {
      return Colors.green;
    } else if (availabilityStatus.toLowerCase() == 'unavailable') {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  IconData getIconForAmenity(String amenity) {
    if (amenity.replaceAll(" ", "").toLowerCase() == 'restroom' ||
        amenity.replaceAll(" ", "").toLowerCase() == 'restroom') {
      return Icons.hotel;
    } else if (amenity.toLowerCase().replaceAll(" ", "") == 'local_cafe') {
      return Icons.local_cafe;
    } else if (amenity.toLowerCase().replaceAll(" ", "") == 'snackarea') {
      return Icons.restaurant;
    } else if (amenity.replaceAll(" ", "").toLowerCase() == 'shops') {
      return Icons.shopping_bag;
    } else if (amenity.replaceAll(" ", "").toLowerCase() == 'wi-fi') {
      return Icons.wifi;
    } else if (amenity.replaceAll(" ", "").toLowerCase() == 'restaurants') {
      return Icons.restaurant;
    } else if (amenity.replaceAll(" ", "").toLowerCase() == 'telephone') {
      return Icons.call;
    } else if (amenity.replaceAll(" ", "").toLowerCase() ==
            'evaccessorystore' ||
        amenity.replaceAll(" ", "").toLowerCase() == 'evaccessarystore') {
      return Icons.store;
    } else if (amenity.replaceAll(" ", "").toLowerCase() == 'garden') {
      return Icons.park_outlined;
    } else {
      return Icons.abc;
    }
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> openGoogleMaps(String url) async {
    try {
      if (await launchUrl(url as Uri)) {
        await launchUrl(url as Uri);
      } else {
        throw 'Could not open Google Maps';
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> checkFavorite() async {
    try {
      const storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getFavoritesByUserId?userId=$userId');
      if (data != null) {
        for (int i = 0; i < data.length; i++) {
          if (widget.stationId == data[i]['stationId']) {
            setState(() {
              isFavorite = true;
            });
            break;
          }
        }
      }
    } catch (e) {
      //print(e);
    }
  }

  //function to launch map with the direction
  void launchMapsDirections(
      double destinationLatitude,
      double destinationLongitude,
      double userLatitude,
      double userLongitude) async {
    // Generate the Google Maps URL
    String mapsUrl = 'https://www.google.com/maps/dir/?api=1';
    mapsUrl += '&origin=$userLatitude,$userLongitude';
    mapsUrl += '&destination=$destinationLatitude,$destinationLongitude';

    // Launch the URL in the Maps application
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not launch $mapsUrl';
    }
  }

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Station"),
        ),
        body: RefreshIndicator(
          key: refreshkey,
          onRefresh: () async {
            setState(() async {
              getStationDetails();
              getChargerList();
              checkFavorite();
              _loadUserRating();
              feedbackList = await fetchFeedback();
            });
            //print("refresh");
          },
          child: CustomScrollView(slivers: <Widget>[
            SliverFillRemaining(
              child: stationDetails == null
                  ? Center(
                      child: LoadingAnimationWidget.waveDots(
                          color: Colors.green, size: 40),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Container for station heading and share button
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06,
                              vertical:
                                  MediaQuery.of(context).size.width * 0.03,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Expanded for station name
                                Expanded(
                                    flex: 6,
                                    child: Marquee(
                                      text:
                                          "${stationDetails!.stationName!}       ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05),
                                    )),

                                //Expanded for share Icon
                                Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          Share.share(
                                              'Check out this EV charging station');
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        )))
                              ],
                            ),
                          ),
                        ),

                        //Container for address, ph. number, add to favorite, active time
                        Expanded(
                          flex: 16,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //Container for station address
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      launchMapsDirections(
                                          stationDetails!.stationLatitude!,
                                          stationDetails!.stationLongitude!,
                                          BgMapState.userLocation!.latitude,
                                          BgMapState.userLocation!.longitude);
                                    },
                                    child: Row(
                                      children: [
                                        //container for location Icon
                                        const Expanded(
                                          child: Icon(Icons.directions,
                                              color: Colors.blue),
                                        ),
                                        //container for station address text
                                        Expanded(
                                          flex: 14,
                                          child: Text(
                                            "   ${stationDetails!.stationArea!}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //Container for station phone number
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _makePhoneCall(
                                          'tel: ${stationDetails!.stationContactNumber}');
                                    },
                                    child: Row(
                                      children: [
                                        //container for call Icon
                                        const Expanded(
                                            child: Icon(Icons.call,
                                                color: Colors.green)),
                                        //container for station contact number
                                        Expanded(
                                          flex: 14,
                                          child: Text(
                                            "   +91 ${stationDetails!.stationContactNumber!}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16
                                                // fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //Container for add to favorite
                                Expanded(
                                  child: Row(
                                    children: [
                                      //container for favorite Icon
                                      Expanded(
                                        child: InkWell(
                                            onTap: () async {
                                              const storage =
                                                  FlutterSecureStorage();
                                              final userId = await storage.read(
                                                  key: 'userId');

                                              setState(() {
                                                if (isFavorite) {
                                                  DeleteMethod.deleteRequest(
                                                      context,
                                                      '${Urls().userUrl}/manageUser/removeFavorite?userId=$userId&stationId=$stationId');

                                                  isFavorite = false;
                                                  widget.isFavoriteadded
                                                      ?.call();
                                                } else {
                                                  PostMethod.postRequest(
                                                      '${Urls().userUrl}/manageUser/addFavorites?userId=$userId',
                                                      jsonEncode({
                                                        "stationId":
                                                            stationDetails!
                                                                .stationId,
                                                        "stationName":
                                                            stationDetails!
                                                                .stationName,
                                                        "stationArea":
                                                            stationDetails!
                                                                .stationArea,
                                                        "stationStatus":
                                                            stationDetails!
                                                                .stationStatus
                                                      }));
                                                  isFavorite = true;
                                                  widget.isFavoriteadded
                                                      ?.call();
                                                }
                                              });
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : Colors.black45,
                                            )),
                                      ),
                                      //container for add to favorite text
                                      const Expanded(
                                        flex: 14,
                                        child: Text(
                                          '   Add to Favorite',
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //Container for station active time and star rating
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //container for watch icon
                                      const Expanded(
                                        // flex: 2,
                                        child: Icon(Icons.watch_later,
                                            color: Colors.orange),
                                      ),
                                      //container for station active time text
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          "   " +
                                              '${stationDetails!.stationOpeningTime} - ${stationDetails!.stationClosingTime}',
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 16
                                              // fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),

                                      Expanded(
                                        flex: 5,
                                        child: Row(
                                          children: List.generate(5, (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReviewForm(
                                                            stationId:
                                                                stationId,
                                                          )),
                                                ).then((value) {
                                                  if (value != null) {
                                                    _loadUserRating();
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                size: 20,
                                                Icons.star,
                                                color: userRating >= index + 1
                                                    ? Colors.orange
                                                    : Colors.grey,
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(
                          color: Colors.black26,
                        ),
                        //Container for Amenity and review button
                        Expanded(
                          flex: 16,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedButton = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: selectedButton
                                            ? Colors.green
                                            : Colors.transparent,
                                      ),
                                      child: Text(
                                        ' Amenities ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedButton
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final feedbackList =
                                          await fetchFeedback();
                                      setState(() {
                                        selectedButton = false;
                                        this.feedbackList = feedbackList;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: selectedButton
                                            ? Colors.transparent
                                            : Colors.green,
                                      ),
                                      child: Text(
                                        ' Reviews ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedButton
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              //This container consist of 2 container for amenities and review
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                child: AnimatedSwitcher(
                                    switchInCurve: Curves.easeInOut,
                                    switchOutCurve: Curves.easeInOut,
                                    duration: const Duration(milliseconds: 500),
                                    child: selectedButton
                                        ?
                                        //Container for Amenities
                                        Container(
                                            margin:
                                                const EdgeInsets.only(left: 11),
                                            alignment: Alignment.center,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: stationDetails!
                                                    .stationAmenity!.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                    child: Column(
                                                      children: [
                                                        //Amenity icon
                                                        Icon(
                                                          getIconForAmenity(
                                                              stationDetails!
                                                                      .stationAmenity![
                                                                  index]),
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                          color: Colors.green,
                                                        ),
                                                        //Amenity text
                                                        Text(
                                                          stationDetails!
                                                                  .stationAmenity![
                                                              index],
                                                          style: TextStyle(
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.04),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          )
                                        :

                                        //Container for reviews
                                        Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            alignment: Alignment.center,
                                            child: isLoading
                                                ? Center(
                                                    child:
                                                        LoadingAnimationWidget
                                                            .inkDrop(
                                                                color: Colors
                                                                    .green,
                                                                size: 40),
                                                  )
                                                : feedbackList.isEmpty
                                                    ? const Text(
                                                        " Feedback is Not Available",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      )
                                                    : ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            feedbackList.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final feedback =
                                                              feedbackList[
                                                                  index];
                                                          // Assuming feedbackRating is a String containing the user's rating as a number (e.g., '4')
                                                          final userRating =
                                                              int.tryParse(feedback
                                                                          .feedbackRating ??
                                                                      '0') ??
                                                                  0;

                                                          return SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.65,
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green
                                                                            .shade100,
                                                                    child: const Icon(
                                                                        Icons
                                                                            .person),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.all(MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.01),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              feedback.userFirstName.toString(),
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            for (int i = 1;
                                                                                i <= 5;
                                                                                i++)
                                                                              Icon(
                                                                                Icons.star,
                                                                                size: 15.0,
                                                                                color: i <= userRating ? Colors.orange : Colors.grey,
                                                                              ),
                                                                          ],
                                                                        ),
                                                                        // Display the review text
                                                                        Text(
                                                                          feedback.feedbackText ??
                                                                              'No feedback available',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.03,
                                                                          ),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                          )),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 45,
                          child: Column(
                            children: [
                              //Container for chargers heading
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: Colors.green, width: 2)),
                                  width: double.maxFinite,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Chargers',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              //Container for charger list
                              Expanded(
                                flex: 23,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),

                                  // height: MediaQuery.of(context).size.height * 0.4,
                                  child: isLoading
                                      ? Center(
                                          child: LoadingAnimationWidget.inkDrop(
                                              color: Colors.green, size: 40),
                                        )
                                      : ListView.builder(
                                          itemCount: chargerList.length,
                                          key: Key(
                                              'builder ${selected.toString()}'),
                                          itemBuilder: (context, index) {
                                            return Card(
                                              margin: EdgeInsets.all(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.015),
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              child: Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        dividerColor:
                                                            Colors.transparent),
                                                child: ExpansionTile(
                                                  key: Key(index.toString()),
                                                  onExpansionChanged:
                                                      ((newState) {
                                                    if (newState) {
                                                      setState(() {
                                                        const Duration(
                                                            seconds: 20000);
                                                        selected = index;
                                                        position = -1;
                                                        chargerId =
                                                            chargerList[index]
                                                                .chargerId;
                                                      });
                                                    } else
                                                      setState(() {
                                                        selected = -1;
                                                      });
                                                  }),
                                                  initiallyExpanded:
                                                      index == selected,
                                                  // isOpenList[index],
                                                  //title - name of charger
                                                  title: Text(
                                                    chargerList[index]
                                                        .chargerName!,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  //subtitle
                                                  subtitle: Text(
                                                      "Connectors: ${chargerList[index].chargerNumberOfConnector}"),

                                                  //children
                                                  children: [
                                                    // column to show connectors
                                                    Column(
                                                      children: [
                                                        Text(
                                                          'Connectors',
                                                          style: TextStyle(
                                                              // fontWeight:
                                                              //     FontWeight.bold,
                                                              fontSize:
                                                                  Get.width *
                                                                      0.047),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        chargerList[index]
                                                                        .connectors ==
                                                                    null ||
                                                                chargerList[
                                                                        index]
                                                                    .connectors!
                                                                    .isEmpty
                                                            ? Padding(
                                                                padding: EdgeInsets.all(
                                                                    Get.height *
                                                                        0.02),
                                                                child:
                                                                    const Text(
                                                                  'No Connector',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                              )
                                                            : ListView
                                                                .separated(
                                                                    shrinkWrap:
                                                                        true,
                                                                    key: Key(
                                                                        'builder ${position.toString()}'),
                                                                    physics:
                                                                        const NeverScrollableScrollPhysics(),
                                                                    separatorBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Divider(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        thickness:
                                                                            1,
                                                                        height:
                                                                            1,
                                                                      );
                                                                    },
                                                                    itemCount: chargerList[
                                                                            index]
                                                                        .connectors!
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            connector) {
                                                                      return ExpansionTile(
                                                                        key: Key(
                                                                            connector.toString()),
                                                                        initiallyExpanded:
                                                                            connector ==
                                                                                position,
                                                                        onExpansionChanged:
                                                                            ((newState) {
                                                                          if (newState) {
                                                                            setState(() {
                                                                              const Duration(seconds: 20000);
                                                                              position = connector;
                                                                              connectorId = chargerList[index].connectors![connector].connectorId!;
                                                                            });
                                                                          } else
                                                                            setState(() {
                                                                              position = -1;
                                                                            });
                                                                          //print( "this is item index: $connector ");
                                                                        }),

                                                                        //Row for connector type and socket
                                                                        title:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                '${chargerList[index].connectors![connector].connectorType!}, ',
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: Get.width * 0.042),
                                                                              ),
                                                                              Text(
                                                                                '${chargerList[index].connectors![connector].connectorSocket}',
                                                                                style: TextStyle(fontSize: Get.width * 0.042),
                                                                              ),
                                                                              const SizedBox(width: 30),
                                                                              Container(
                                                                                height: 40,
                                                                                width: 100,
                                                                                child: Card(
                                                                                  color: Colors.white,
                                                                                  elevation: 3,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    children: [
                                                                                      Text(
                                                                                        getAvailabilityColor(chargerList[index].connectors![connector].connectorStatus!) == Colors.green ? "Available" : "Unavailable",
                                                                                        style: const TextStyle(
                                                                                          fontWeight: FontWeight.bold,
                                                                                          fontSize: 11,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        width: 8,
                                                                                      ),
                                                                                      CircleAvatar(
                                                                                        backgroundColor: getAvailabilityColor(
                                                                                          chargerList[index].connectors![connector].connectorStatus!,
                                                                                        ),
                                                                                        radius: 5,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        //Row for cost and o/p power
                                                                        subtitle:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 8.0,
                                                                              bottom: 8.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              //Row for cost
                                                                              Row(
                                                                                children: [
                                                                                  const Text(
                                                                                    'Cost: ',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                                                                  ),
                                                                                  Text(
                                                                                    chargerList[index].connectors![connector].connectorCharges != null
                                                                                        ? "₹ ${(chargerList[index].connectors![connector].connectorCharges! / 100).toStringAsFixed(2)}"
                                                                                        // ? chargerList[index].connectors![connector].connectorCharges!.toStringAsFixed(2) // Format as a string with 2 decimal places
                                                                                        : 'N/A', // Handle the case where connectorCharges is null
                                                                                    style: const TextStyle(
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const Text(' '),
                                                                              //Row for o/p power
                                                                              Row(
                                                                                children: [
                                                                                  const Text(
                                                                                    'O/P Power: ',
                                                                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                                                                  ),
                                                                                  Text(
                                                                                    '${chargerList[index].connectors![connector].connectorOutputPower}',
                                                                                    style: const TextStyle(color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        //children for reserve and charge button
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              //button for reserve
                                                                              ElevatedButton(
                                                                                  onPressed: () {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (BuildContext context) {
                                                                                          return AlertDialog(
                                                                                            content: const Text('Regret !! reservation currently not available for this charger'),
                                                                                            actions: [
                                                                                              ElevatedButton(
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                  child: const Text('OK'))
                                                                                            ],
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: Colors.amber, // Set the button color to orange
                                                                                  ),
                                                                                  child: const Text('Reserve')),
                                                                              //button for charge
                                                                              getAvailabilityColor(chargerList[index].connectors![connector].connectorStatus!) == Colors.green
                                                                                  ? ElevatedButton(
                                                                                      onPressed: () {
                                                                                        //print("data for next page : ${stationId}, ${chargerId}, ${connectorId}");
                                                                                        showModalBottomSheet(
                                                                                          isScrollControlled: true,
                                                                                          shape: const RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.vertical(
                                                                                              top: Radius.circular(30.0),
                                                                                            ),
                                                                                          ),
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return Container(
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                              ),
                                                                                              child: Wrap(
                                                                                                children: [
                                                                                                  Container(
                                                                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                                                                    decoration: const BoxDecoration(
                                                                                                      borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(20.0),
                                                                                                        topRight: Radius.circular(20.0),
                                                                                                      ),
                                                                                                    ),
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        // used to handle the onFocus() activities
                                                                                                        FocusScope.of(context).unfocus();
                                                                                                      },
                                                                                                      child: Container(
                                                                                                        alignment: Alignment.bottomCenter,
                                                                                                        // margin: const EdgeInsets.only(top: 20),
                                                                                                        child: Column(
                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                          children: [
                                                                                                            Container(
                                                                                                              width: 60,
                                                                                                              child: const Divider(
                                                                                                                color: Colors.green,
                                                                                                                thickness: 3,
                                                                                                              ),
                                                                                                            ),
                                                                                                            const SizedBox(
                                                                                                              height: 10,
                                                                                                            ),
                                                                                                            const Padding(
                                                                                                              padding: EdgeInsets.all(15.0),
                                                                                                              child: Text(
                                                                                                                "Want to go for a full charge?",
                                                                                                                style: TextStyle(
                                                                                                                  fontSize: 23,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),

                                                                                                            // button for Start Charging
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.all(15.0),
                                                                                                              child: InkWell(
                                                                                                                onTap: () async {
                                                                                                                  var start = StartChargingService(context);
                                                                                                                  final userId = await storage.read(key: 'userId');
                                                                                                                  start.startChargingApiCall("${userId}", "${userId}", index.toString(), "VPEL", 0, 0, 0, "fullCharging");
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                    alignment: Alignment.center,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: Colors.green,
                                                                                                                        border: Border.all(color: Colors.green, width: 1.0, style: BorderStyle.solid),
                                                                                                                        borderRadius: const BorderRadius.all(
                                                                                                                          Radius.circular(5),
                                                                                                                        )),
                                                                                                                    width: MediaQuery.of(context).size.width,
                                                                                                                    child: const Padding(
                                                                                                                      padding: EdgeInsets.all(8.0),
                                                                                                                      child: Text(
                                                                                                                        "Start Charging",
                                                                                                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                                                                                                      ),
                                                                                                                    )),
                                                                                                              ),
                                                                                                            ),

                                                                                                            // button for Customize
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.all(15.0),
                                                                                                              child: InkWell(
                                                                                                                onTap: () {
                                                                                                                  // customizeSheet();
                                                                                                                  showModalBottomSheet(
                                                                                                                    isScrollControlled: true,
                                                                                                                    shape: const RoundedRectangleBorder(
                                                                                                                      borderRadius: BorderRadius.vertical(
                                                                                                                        top: Radius.circular(30.0),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    context: context,
                                                                                                                    builder: (BuildContext context) {
                                                                                                                      return Container(
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          borderRadius: BorderRadius.circular(20.0),
                                                                                                                        ),
                                                                                                                        child: Wrap(
                                                                                                                          children: [
                                                                                                                            Container(
                                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                                                                                              decoration: const BoxDecoration(
                                                                                                                                borderRadius: BorderRadius.only(
                                                                                                                                  topLeft: Radius.circular(20.0),
                                                                                                                                  topRight: Radius.circular(20.0),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              child: GestureDetector(
                                                                                                                                onTap: () {
                                                                                                                                  // used to handle the onFocus() activities
                                                                                                                                  FocusScope.of(context).unfocus();
                                                                                                                                },
                                                                                                                                child: Container(
                                                                                                                                  alignment: Alignment.bottomCenter,
                                                                                                                                  child: Column(
                                                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                    children: [
                                                                                                                                      Container(
                                                                                                                                        width: 60,
                                                                                                                                        child: const Divider(
                                                                                                                                          color: Colors.green,
                                                                                                                                          thickness: 3,
                                                                                                                                        ),
                                                                                                                                      ),
                                                                                                                                      const SizedBox(
                                                                                                                                        height: 10,
                                                                                                                                      ),

                                                                                                                                      TimeUnitMoney(userId: widget.userId, connectorIndex: index.toString(), activeButton: activeButton, timeSliderValue: timeSliderValue, unitsSliderValue: unitsSliderValue, moneySliderValue: moneySliderValue),

                                                                                                                                      const SizedBox(
                                                                                                                                        height: 30,
                                                                                                                                      ),

                                                                                                                                      // added so that when keyboard pops up, sheet should not hide behind
                                                                                                                                      Padding(padding: MediaQuery.of(context).viewInsets)
                                                                                                                                    ],
                                                                                                                                  ),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    },
                                                                                                                  );
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                    alignment: Alignment.center,
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        border: Border.all(color: Colors.green, width: 1.0, style: BorderStyle.solid),
                                                                                                                        borderRadius: const BorderRadius.all(
                                                                                                                          Radius.circular(5),
                                                                                                                        )),
                                                                                                                    width: MediaQuery.of(context).size.width,
                                                                                                                    child: const Padding(
                                                                                                                        padding: EdgeInsets.all(8.0),
                                                                                                                        child: Row(
                                                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                                                          children: [
                                                                                                                            Text(
                                                                                                                              "Customize",
                                                                                                                              style: TextStyle(fontSize: 20, color: Colors.green),
                                                                                                                            ),
                                                                                                                          ],
                                                                                                                        ))),
                                                                                                              ),
                                                                                                            ),

                                                                                                            const SizedBox(
                                                                                                              height: 30,
                                                                                                            ),

                                                                                                            // added so that when keyboard pops up, sheet should not hide behind
                                                                                                            Padding(padding: MediaQuery.of(context).viewInsets)
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: const Text('Charge'),
                                                                                    )
                                                                                  : ElevatedButton(
                                                                                      onPressed: () {},
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        primary: Colors.grey,
                                                                                      ),
                                                                                      child: const Text('Charge'),
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 40.0, right: 40.0),
                                                                            child:
                                                                                Divider(
                                                                              color: Colors.black26,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    })
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            )
          ]),
        ),
      ),
    );
  }
}
