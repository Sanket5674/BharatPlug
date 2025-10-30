import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ReservationDonePopUp extends StatefulWidget {
  String stationName;
  String chargerSerialNumber;
  String stationLocation;
  String bookingId;
  String bookginStatus;
  DateTime bookingDate;
  DateTime bookingTime;

  ReservationDonePopUp(
      {required this.stationName,
      required this.stationLocation,
      required this.bookingDate,
      required this.bookingTime,
      required this.bookingId,
      required this.chargerSerialNumber,
      required this.bookginStatus,
      super.key});

  @override
  State<StatefulWidget> createState() => ReservationDonePopUpState();
}

class ReservationDonePopUpState extends State<ReservationDonePopUp> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        children: [
          //Container for the top icon
          SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              //this stack consist of a container with a color and a icon in center
              child: Stack(
                children: [
                  //container has half the height of its parent container, so that it should fit according to the design
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 137, 175, 76),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    // width: double.infinity / 2,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  //this consist of the done Icon
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          Icons.done_rounded,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    ),
                  ),
                  //Cross Button
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.x,
                            color: Colors.white,
                            size: 20,
                          )))
                ],
              )),

          //Container for other details
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.width * 0.02),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Column for station name and chargerId
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Container for station name
                        Text(
                          widget.stationName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        ),

                        //Container for charger Serial number
                        Row(
                          children: [
                            Text(
                              'ChargerId: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                            ),
                            Text(
                              widget.chargerSerialNumber,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Container for station location
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.stationLocation,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  //Container for station booking Id and booking station
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //column for booking Id
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Booking Id',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(widget.bookingId)
                          ],
                        ),

                        //column for booking Status
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Booking Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(widget.bookginStatus),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Container for booking date and time
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Booking Date & Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(DateFormat('MMM dd, yyyy')
                                .format(widget.bookingDate)),
                            Text(DateFormat('HH:MM a')
                                .format(widget.bookingTime)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Container for socket type and booking amount
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //column for socket type
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Socket Type',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Type 2')
                          ],
                        ),

                        //column for booking amount
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(
                              'Booking Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                const Text('198 Inc. Taxes'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
