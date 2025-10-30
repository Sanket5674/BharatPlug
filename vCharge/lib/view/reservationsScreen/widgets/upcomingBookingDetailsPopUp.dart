import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vcharge/services/GetMethod.dart';

import '../../../models/bookingModel.dart';
import '../../../services/urls.dart';
import '../../connectivity_service.dart';
import 'cancelReservAlertPopUp.dart';

// ignore: must_be_immutable
class UpcomingBookingDetailsPopUp extends StatefulWidget {
  BookingModel bookingModel;
  String? stationName;
  String? stationAddress;

  UpcomingBookingDetailsPopUp(
      {required this.bookingModel,
      required this.stationName,
      required this.stationAddress,
      super.key});

  @override
  State<UpcomingBookingDetailsPopUp> createState() =>
      UpcomingBookingDetailsPopUpState();
}

class UpcomingBookingDetailsPopUpState
    extends State<UpcomingBookingDetailsPopUp> {
  final ConnectivityService _connectivityService = ConnectivityService();

  BookingModel? bookingModel;
  String? stationAddress;

  @override
  void initState() {
    bookingModel = widget.bookingModel;
    getStationAddress();
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      final snackBar = SnackBar(
        content: Text('No internet connection'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Return early to avoid the rest of the code
    }
// The rest of your logic (e.g., loading station data) can go here
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getStationAddress() async {
    var data = await GetMethod.getRequest(context,
        '${Urls().stationUrl}/manageStation/getStationAddress?stationId=${widget.bookingModel.stationId}');
    setState(() {
      stationAddress =
          "${data['stationAddressLineOne']} ${data['stationAddressLineTwo']}, ${data['stationArea']}, ${data['stationCity']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.55,
      child: Column(children: [
        //"Booking Details" Heading text
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 113, 174, 76),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Center(
                child: Text(
              'Booking Details',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.025),
            )),
          ),
        ),

        //ListTile for station name, address and direction icon
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
            child: ListTile(
              title: Text(
                widget.stationName!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Get.width * 0.05),
              ),
              subtitle: stationAddress == null
                  ? const Text("...")
                  : Text(
                      stationAddress!,
                      maxLines: 3,
                    ),
              trailing: IconButton(
                icon: const Icon(Icons.directions),
                onPressed: () {},
              ),
            ),
          ),
        ),

        //Row for booking ID and booking Status
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Column for booking Id
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Booking Id',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      bookingModel!.bookingId!,
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              //Column for booking Status
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Booking Status',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      bookingModel!.bookingStatus!,
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        //Row for booking date and booking Time
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Column for booking date
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Booking Date',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      DateFormat("dd MMM, yyyy")
                          .format(DateTime.parse(bookingModel!.bookingDate!)),
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              //Column for booking time
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Booking Time',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      bookingModel!.bookingTime!,
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        //Row for Socket type and booking amount
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Column for socket type
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Socket Type',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      bookingModel!.bookingSocket!,
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),

              //Column for booking amount
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Booking Amount',
                      style: TextStyle(
                          fontSize: Get.width * 0.04, color: Colors.grey),
                    ),
                    Text(
                      'Rs. ${bookingModel!.bookingAmount!}',
                      style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
            flex: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //button for start charging
                InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(Get.width * 0.035),
                      child: const Text(
                        'Start Charging',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                //button for cancel booking
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return CancleReservAlertPopUp(
                            bookingModel: widget.bookingModel,
                          );
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.green),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(Get.width * 0.03),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ]),
    );
  }
}
