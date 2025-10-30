import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/services/PostMethod.dart';
import 'package:vcharge/view/stationsSpecificDetails/widgets/reservationDonePopup.dart';
import 'package:vcharge/view/walletScreen/addMoneyScreen.dart';
import '../../../models/chargerModel.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../../../services/urls.dart';

// ignore: must_be_immutable
class ReservePopUp extends StatefulWidget {
  String stationId;
  String stationName;
  String stationHostId;
  String stationVendorId;
  String stationLocation;
  ChargerModel chargerModel;
  String connecterId;
  String connectorSocket;
  String userId;

  ReservePopUp(
      {required this.userId,
      required this.stationId,
      required this.stationName,
      required this.stationHostId,
      required this.stationVendorId,
      required this.stationLocation,
      required this.chargerModel,
      required this.connecterId,
      required this.connectorSocket,
      super.key});

  @override
  State<StatefulWidget> createState() => ReservePopUpState();
}

class ReservePopUpState extends State<ReservePopUp> {
  String? stationName;
  String? stationLocation;
  ChargerModel? chargerModel;

  var selectedDate = DateTime.now();
  DateTime selectedTimeSlot = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  List<DateTime>? timeSlotsList;
  double? walletAmount;

  @override
  void initState() {
    stationName = widget.stationName;
    stationLocation = widget.stationLocation;
    chargerModel = widget.chargerModel;
    // Generate a list of DateTime objects representing each hour slot in the current day
    timeSlotsList = timeSlots();
    getWalletAmount();
    super.initState();
  }

  Future<int> postBooking(body) async {
    var data = await PostMethod.postRequest(
        '${Urls().bookingUrl}/manageBooking/addBooking', body);
    return data;
  }

  Future<void> getWalletAmount() async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getWalletByUserId?userId=${widget.userId}');
      setState(() {
        walletAmount = data['walletAmount'];
      });
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  // This method generates a list of DateTime objects representing each hour slot in the current day
  List<DateTime> timeSlots() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0,
        0); // Get the start of the current day
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59,
        59); // Get the end of the current day
    final hourSlots =
        <DateTime>[]; // Initialize an empty list to store the hour slots
    // Loop through each hour in the current day and add it to the hourSlots list
    for (var i = startOfDay;
        i.isBefore(endOfDay);
        i = i.add(const Duration(hours: 1))) {
      hourSlots.add(i);
    }
    return hourSlots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //this container contains a wrap, which consist 2 text -> stationName and chargerName
            Wrap(
              direction: Axis.vertical,
              children: [
                //Station Heading text
                Text(
                  stationName!,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
                //Station Heading text
                Text(chargerModel!.chargerSerialNumber!),
              ],
            ),

            //container for station location
            Row(
              children: [
                const Icon(Icons.location_on_rounded),
                Text(
                  stationLocation!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),

            //Container for socket and avaliblity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //container for charger socket
                Row(
                  children: [
                    const Text(
                      'Socket: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${chargerModel!.chargerMountType}',
                    ),
                  ],
                ),

                //container for charger availiblity
                const Row(
                  children: [
                    Text(
                      'Availability: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Available',
                    ),
                  ],
                ),
              ],
            ),

            //Column for date picker
            Column(
              children: [
                //container for date text
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Choose a date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                      Text(DateFormat('MMM dd, yyyy').format(selectedDate),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035))
                    ],
                  ),
                ),
                //container for date picker
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: DatePicker(
                      DateTime.now(),
                      initialSelectedDate: selectedDate,
                      selectionColor: const Color.fromARGB(255, 148, 192, 83),
                      selectedTextColor: Colors.white,
                      onDateChange: (date) {
                        // New date selected
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            //column for timeslot dropdown
            Column(
              children: [
                //container for choose time text
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose your slot',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                //container for time slot drop down
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: // Return a DropdownButton widget with the following properties:
                      Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                        vertical: MediaQuery.of(context).size.width * 0.015),
                    child: DropdownButton<DateTime>(
                        underline: Container(),
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
                        isExpanded: true,
                        value:
                            selectedTimeSlot, // Set the currently selected time slot as the initial value
                        onChanged: (value) {
                          // When the user selects a time slot, update the selectedTimeSlot variable and rebuild the widget
                          setState(() {
                            selectedTimeSlot = value!;
                          });
                        },
                        // Create a list of DropdownMenuItem widgets based on the timeSlots list
                        items: timeSlotsList!
                            .map(
                              (e) => DropdownMenuItem<DateTime>(
                                value:
                                    e, // Set the value of the DropdownMenuItem to the current time slot
                                // Display the hour value of the time slot as a Text widget
                                child: Text(
                                  '${e.hour.toString().padLeft(2, '0')}:00', // Format the hour value as a two-digit string with leading zeros
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                            .toList()),
                  ),
                ),
              ],
            ),

            //Container for wallet balance and credit button
            Container(
              decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        const Text('Wallet balance is '),
                        //rupees icon
                        Icon(
                          Icons.currency_rupee,
                          size: MediaQuery.of(context).size.width * 0.05,
                        ),
                        walletAmount == null
                            ? LoadingAnimationWidget.inkDrop(
                                color: Colors.green, size: 40)
                            : Text(
                                '$walletAmount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.045),
                              ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddMoneyScreen(userId: widget.userId)));
                        },
                        child: const Text('Credit'))
                  ],
                ),
              ),
            ),

            //Container for reserve button
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    var response = await postBooking(jsonEncode({
                      "bookingType": "Reservation",
                      "hostId": widget.stationHostId,
                      "customerId": widget.userId,
                      "stationId": widget.stationId,
                      "bookingDate":
                          DateFormat("yyyy-MM-dd").format(selectedDate),
                      "bookingTime":
                          DateFormat("HH:mm:ss").format(selectedTimeSlot),
                      "bookingSocket": widget.connectorSocket,
                      "bookingStatus": "confirmed",
                      "stationName": widget.stationName,
                      "chargerId": widget.chargerModel.chargerId,
                      "connectorId": widget.connecterId,
                    }));
                    if (response == 200) {
                      // ignore: use_build_context_synchronously
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ReservationDonePopUp(
                              stationName: widget.stationName,
                              chargerSerialNumber:
                                  chargerModel!.chargerSerialNumber!,
                              stationLocation: widget.stationLocation,
                              bookingId: 'BKG0012324',
                              bookginStatus: 'Confirmed',
                              bookingDate: selectedDate,
                              bookingTime: selectedTimeSlot,
                            );
                          });
                    }
                  } catch (e) {
                    // Components().showSnackbar(
                    //     Components().something_want_wrong, context);
                    //print(e);
                  }
                },
                child: const Text(
                  'Reserve',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
