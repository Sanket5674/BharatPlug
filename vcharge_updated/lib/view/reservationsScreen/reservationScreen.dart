import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vcharge/models/bookingModel.dart';
import 'package:vcharge/services/GetMethod.dart';
import '../../services/urls.dart';

// ignore: must_be_immutable
class ReservationScreen extends StatefulWidget {
  String userId;

  ReservationScreen({required this.userId, super.key});
  @override
  State<StatefulWidget> createState() => ReservationScreenState();
}

class ReservationScreenState extends State<ReservationScreen> {
  bool upcomingButton = true;
  bool historyButton = false;

  String? stationAddress;
  List<BookingModel> upcomingBookingList = [];
  List<BookingModel> bookingHistoryList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getbookingDetails('${widget.userId}');
    getStationAddress('STN20231004100447454');
    Future.delayed(const Duration(seconds: 10), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> getStationAddress(String stationId) async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().stationUrl}/manageStation/getStation?stationId=$stationId');
      setState(() {
        stationAddress =
            '${data['stationAddressLineOne']}, ${data['stationAddressLineTwo']}, ${data['stationCity']}';
      });
    } catch (e) {
      ////print(e);
    }
  }

  Future<void> getbookingDetails(String userId) async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().bookingUrl}/manageBooking/getBookingByCustomerId?customerId=$userId');
      if (data != null && data.isNotEmpty) {
        upcomingBookingList.clear();
        bookingHistoryList.clear();
        setState(() {
          for (int i = 0; i < data.length; i++) {
            BookingModel booking = BookingModel.fromJson(data[i]);
            var bookingDateTime =
                DateTime.parse('${booking.bookingDate} ${booking.bookingTime}');
            if (bookingDateTime.isAfter(DateTime.now()) &&
                booking.bookingStatus!.toLowerCase() != 'cancelled' &&
                booking.bookingStatus!.toLowerCase() != 'completed') {
              upcomingBookingList.add(booking);
            } else {
              bookingHistoryList.add(booking);
            }
          }
        });
      }
    } catch (e) {
      ////print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //appBar
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Reservations'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Lottie.asset('assets/images/ComingSoon.json'),
              ),
              //Row for Upcoming and History button
              // Expanded(
              //     flex: 2,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         //Elevated Button for Upcoming
              //         ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(30)),
              //                 backgroundColor: upcomingButton
              //                     ? Colors.green
              //                     : Colors.white),
              //             onPressed: () {
              //               setState(() {
              //                 upcomingButton = true;
              //                 historyButton = false;
              //               });
              //             },
              //             child: Text(
              //               'Upcoming',
              //               style: TextStyle(
              //                   color: upcomingButton
              //                       ? Colors.white
              //                       : Colors.black,
              //                   fontWeight: FontWeight.bold),
              //             )),
              //
              //         //Elevated Button for History
              //         ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(30)),
              //                 backgroundColor: historyButton
              //                     ? const Color.fromARGB(255, 123, 201, 67)
              //                     : Colors.white),
              //             onPressed: () {
              //               setState(() {
              //                 upcomingButton = false;
              //                 historyButton = true;
              //               });
              //             },
              //             child: Text('History',
              //                 style: TextStyle(
              //                     color: historyButton
              //                         ? Colors.white
              //                         : Colors.black,
              //                     fontWeight: FontWeight.bold))),
              //       ],
              //     )),
              //
              // //Expanded for to show the list of reservations
              // Expanded(
              //   flex: 15,
              //   child: upcomingButton == true
              //       ? isLoading
              //           ? Center(
              //               child: LoadingAnimationWidget.inkDrop(
              //                   color: Colors.green, size: 40),
              //             )
              //           : upcomingBookingList.isEmpty
              //               ? Center(
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Image.asset(
              //                         "assets/images/NoData.png",
              //                       ),
              //                       const Text(
              //                         "No Data Available !",
              //                         style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 18),
              //                       ),
              //                     ],
              //                   ),
              //                 )
              //               : ListView.builder(
              //                   itemCount: upcomingBookingList.length,
              //                   itemBuilder: (context, index) {
              //                     return InkWell(
              //                       onTap: () {
              //                         showModalBottomSheet(
              //                             context: context,
              //                             shape: const RoundedRectangleBorder(
              //                               borderRadius: BorderRadius.only(
              //                                   topLeft: Radius.circular(20),
              //                                   topRight: Radius.circular(20)),
              //                             ),
              //                             builder: (context) {
              //                               return stationAddress == null
              //                                   ? Center(
              //                                       child:
              //                                           LoadingAnimationWidget
              //                                               .inkDrop(
              //                                                   color: Colors
              //                                                       .green,
              //                                                   size: 40),
              //                                     )
              //                                   : UpcomingBookingDetailsPopUp(
              //                                       bookingModel:
              //                                           upcomingBookingList[
              //                                               index],
              //                                       stationAddress:
              //                                           stationAddress,
              //                                       stationName:
              //                                           upcomingBookingList[
              //                                                   index]
              //                                               .stationName,
              //                                     );
              //                             }).then((value) {
              //                           setState(() {
              //                             getStationAddress(
              //                                 'STN20231004100447454');
              //                             getbookingDetails('${widget.userId}');
              //                           });
              //                         });
              //                       },
              //                       child: Card(
              //                           elevation: 3,
              //                           shape: RoundedRectangleBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(10)),
              //                           color: const Color.fromARGB(
              //                               255, 235, 255, 254),
              //                           margin: EdgeInsets.symmetric(
              //                               horizontal: Get.width * 0.02,
              //                               vertical: Get.height * 0.01),
              //                           child: Padding(
              //                             padding: const EdgeInsets.all(8.0),
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 // //Station Name
              //                                 Text(
              //                                   upcomingBookingList[index]
              //                                       .stationName!,
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.bold,
              //                                       fontSize: Get.width * 0.05),
              //                                 ),
              //
              //                                 //Row for booking ID, socket Type, and booking Status
              //                                 Container(
              //                                   margin: EdgeInsets.symmetric(
              //                                       vertical:
              //                                           Get.height * 0.005),
              //                                   child: Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceEvenly,
              //                                     children: [
              //                                       //Column Booking ID
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Booking Id',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: const Color
              //                                                       .fromARGB(
              //                                                       255,
              //                                                       203,
              //                                                       255,
              //                                                       204),
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       upcomingBookingList[
              //                                                               index]
              //                                                           .bookingId!,
              //                                                       maxLines: 1,
              //                                                       overflow:
              //                                                           TextOverflow
              //                                                               .ellipsis,
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //
              //                                       //Column Socket Type
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Socket Type',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: const Color
              //                                                       .fromARGB(
              //                                                       255,
              //                                                       203,
              //                                                       255,
              //                                                       204),
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       upcomingBookingList[
              //                                                               index]
              //                                                           .bookingSocket!,
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Booking Status',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: Colors
              //                                                       .white,
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       upcomingBookingList[
              //                                                               index]
              //                                                           .bookingStatus!
              //                                                           .toUpperCase(),
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03,
              //                                                           color: Colors
              //                                                               .green),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ),
              //
              //                                 //Wrap for date and time
              //                                 Container(
              //                                   margin: EdgeInsets.symmetric(
              //                                       vertical:
              //                                           Get.height * 0.004),
              //                                   child: Wrap(
              //                                     spacing: 20,
              //                                     children: [
              //                                       Text(DateFormat(
              //                                               "dd MMM, yyyy")
              //                                           .format(DateTime.parse(
              //                                               upcomingBookingList[
              //                                                       index]
              //                                                   .bookingDate!))),
              //                                       Text(upcomingBookingList[
              //                                               index]
              //                                           .bookingTime!),
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           )),
              //                     );
              //                   })
              //       : //List for history
              //       isLoading
              //           ? Center(
              //               child: LoadingAnimationWidget.inkDrop(
              //                   color: Colors.green, size: 40),
              //             )
              //           : bookingHistoryList.isEmpty
              //               ? Center(
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Image.asset(
              //                         "assets/images/NoData.png",
              //                       ),
              //                       const Text(
              //                         "No Data Available !",
              //                         style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 18),
              //                       ),
              //                     ],
              //                   ),
              //                 )
              //               : ListView.builder(
              //                   itemCount: bookingHistoryList.length,
              //                   itemBuilder: (context, index) {
              //                     return InkWell(
              //                       onTap: () {
              //                         showDialog(
              //                             context: context,
              //                             builder: (context) {
              //                               return BookingHistoryDetailsPopUp(
              //                                 bookingModel:
              //                                     bookingHistoryList[index],
              //                                 stationName:
              //                                     bookingHistoryList[index]
              //                                         .stationName!,
              //                               );
              //                             });
              //                       },
              //                       child: Card(
              //                           elevation: 3,
              //                           shape: RoundedRectangleBorder(
              //                               borderRadius:
              //                                   BorderRadius.circular(10)),
              //                           color: const Color.fromARGB(
              //                               255, 235, 255, 254),
              //                           margin: EdgeInsets.symmetric(
              //                               horizontal: Get.width * 0.02,
              //                               vertical: Get.height * 0.01),
              //                           child: Padding(
              //                             padding: const EdgeInsets.all(8.0),
              //                             child: Column(
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 //Station Name
              //                                 Text(
              //                                   bookingHistoryList[index]
              //                                       .stationName!,
              //                                   style: TextStyle(
              //                                       fontWeight: FontWeight.bold,
              //                                       fontSize: Get.width * 0.05),
              //                                 ),
              //
              //                                 //Row for booking ID, socket Type, and booking Status
              //                                 Container(
              //                                   margin: EdgeInsets.symmetric(
              //                                       vertical:
              //                                           Get.height * 0.005),
              //                                   child: Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceEvenly,
              //                                     children: [
              //                                       //Column Booking ID
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Booking Id',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: const Color
              //                                                       .fromARGB(
              //                                                       255,
              //                                                       203,
              //                                                       255,
              //                                                       204),
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       bookingHistoryList[
              //                                                               index]
              //                                                           .bookingId!,
              //                                                       maxLines: 1,
              //                                                       overflow:
              //                                                           TextOverflow
              //                                                               .ellipsis,
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //
              //                                       //Column Socket Type
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Socket Type',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: const Color
              //                                                       .fromARGB(
              //                                                       255,
              //                                                       203,
              //                                                       255,
              //                                                       204),
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       bookingHistoryList[
              //                                                               index]
              //                                                           .bookingSocket!,
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //
              //                                       //Column booking status
              //                                       Expanded(
              //                                         child: SizedBox(
              //                                           height:
              //                                               Get.height * 0.07,
              //                                           child: Column(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .spaceAround,
              //                                             children: [
              //                                               Text(
              //                                                 'Booking Status',
              //                                                 style: TextStyle(
              //                                                     fontSize:
              //                                                         Get.width *
              //                                                             0.035,
              //                                                     fontWeight:
              //                                                         FontWeight
              //                                                             .bold),
              //                                               ),
              //                                               Card(
              //                                                   elevation: 0,
              //                                                   color: Colors
              //                                                       .white,
              //                                                   child: Padding(
              //                                                     padding: EdgeInsets.symmetric(
              //                                                         vertical:
              //                                                             Get.height *
              //                                                                 0.004,
              //                                                         horizontal:
              //                                                             Get.width *
              //                                                                 0.015),
              //                                                     child: Text(
              //                                                       bookingHistoryList[
              //                                                               index]
              //                                                           .bookingStatus!
              //                                                           .toUpperCase(),
              //                                                       style: TextStyle(
              //                                                           fontSize:
              //                                                               Get.width *
              //                                                                   0.03,
              //                                                           color: Colors
              //                                                               .green),
              //                                                     ),
              //                                                   ))
              //                                             ],
              //                                           ),
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ),
              //
              //                                 //Wrap for date and time
              //                                 Container(
              //                                   margin: EdgeInsets.symmetric(
              //                                       vertical:
              //                                           Get.height * 0.004),
              //                                   child: Wrap(
              //                                     spacing: 20,
              //                                     children: [
              //                                       Text(DateFormat(
              //                                               "dd MMM, yyyy")
              //                                           .format(DateTime.parse(
              //                                               bookingHistoryList[
              //                                                       index]
              //                                                   .bookingDate!))),
              //                                       Text(bookingHistoryList[
              //                                               index]
              //                                           .bookingTime!),
              //                                     ],
              //                                   ),
              //                                 ),
              //
              //                                 //Wrap for amount paid
              //                                 Container(
              //                                   margin: EdgeInsets.symmetric(
              //                                       vertical:
              //                                           Get.height * 0.004),
              //                                   child: Row(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment
              //                                             .spaceBetween,
              //                                     children: [
              //                                       //Row for amount paid
              //                                       Row(
              //                                         children: [
              //                                           const Text(
              //                                             'Amount Paid',
              //                                             style: TextStyle(
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold),
              //                                           ),
              //                                           Card(
              //                                               elevation: 0,
              //                                               color: const Color
              //                                                   .fromARGB(255,
              //                                                   203, 255, 204),
              //                                               child: Padding(
              //                                                 padding: EdgeInsets.symmetric(
              //                                                     vertical:
              //                                                         Get.height *
              //                                                             0.004,
              //                                                     horizontal:
              //                                                         Get.width *
              //                                                             0.015),
              //                                                 child: const Text(
              //                                                   'Rs. 300',
              //                                                   style: TextStyle(
              //                                                       fontWeight:
              //                                                           FontWeight
              //                                                               .bold),
              //                                                 ),
              //                                               )),
              //                                         ],
              //                                       ),
              //
              //                                       Text(
              //                                         'Consumed 1.5 kWh',
              //                                         style: TextStyle(
              //                                             fontSize:
              //                                                 Get.width * 0.04,
              //                                             color: Colors.green),
              //                                       )
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           )),
              //                     );
              //                   }),
              // )
            ],
          )),
    );
  }
}
