import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/bookingModel.dart';
import '../../connectivity_service.dart';

// ignore: must_be_immutable
class BookingHistoryDetailsPopUp extends StatefulWidget {
  String stationName;
  BookingModel bookingModel;

  BookingHistoryDetailsPopUp(
      {required this.bookingModel, required this.stationName, super.key});

  @override
  State<StatefulWidget> createState() => BookingHistoryDetailsPopUpState();
}

class BookingHistoryDetailsPopUpState
    extends State<BookingHistoryDetailsPopUp> {
  final ConnectivityService _connectivityService = ConnectivityService();
  @override
  void initState() {
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
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Container for heading Text
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 113, 174, 76),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                      child: Padding(
                    padding: EdgeInsets.all(Get.height * 0.008),
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.height * 0.025),
                    ),
                  )),
                ),
                //Cross button
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsets.all(Get.width * 0.03),
                        child: FaIcon(
                          FontAwesomeIcons.x,
                          color: Colors.white,
                          size: Get.width * 0.045,
                        ),
                      )),
                ),
              ],
            ),

            //Row for Booking Id
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Booking Id',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    widget.bookingModel.bookingId!,
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //Row for Booking Date and Time
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Booking Date and Time',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("dd MMM, yyyy").format(
                            DateTime.parse(widget.bookingModel.bookingDate!)),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.bookingModel.bookingTime!,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ))
                ],
              ),
            ),

            //Row for Booked for
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                children: const [
                  Expanded(
                      child: Text(
                    'Booking for',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    '1hr 30min',
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //Row for Charged for
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                children: const [
                  Expanded(
                      child: Text(
                    'Charged For',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    '1hr',
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //Row for Charger
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Charger',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    widget.stationName,
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //Row for Socket Type
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                      child: Text(
                    'Socket Type',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    widget.bookingModel.bookingSocket!,
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //Row for Energy Consumed
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                      child: Text(
                    'Energy Consumed',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text(
                    '13 kWh',
                    textAlign: TextAlign.left,
                  ))
                ],
              ),
            ),

            //pricing details
            Container(
              margin: EdgeInsets.all(Get.width * 0.025),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 230, 250, 255),
                  borderRadius: BorderRadius.circular(10)),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(Get.width * 0.008),
                child: Column(
                  children: [
                    //pricing details heading
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Text(
                        'Pricing Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.width * 0.045),
                      ),
                    ),

                    //Row for Price Per Unit
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Price Per Unit',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 15/kWh',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Row for Subtotal
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Subtotal',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Row for GST
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'GST',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Row for Parking Charges
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Parking Charges',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Row for Service Charging
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Service Charging',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Row for GST on Service Charge
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'GST on Service Charge',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),

                    //Divider
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: const Divider(
                        color: Colors.grey,
                        thickness: 1,
                        height: 1,
                      ),
                    ),

                    //Row for Total Price
                    Padding(
                      padding: EdgeInsets.all(Get.width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Total Price',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rs. 0.00',
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Payment made using wallet card
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
                child: Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: const [
                        Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.wallet,
                              color: Colors.green,
                            )),
                        Expanded(
                            flex: 11,
                            child: Text(
                              'Payment Made Using Wallet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
