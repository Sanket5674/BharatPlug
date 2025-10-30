import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../models/bookingModel.dart';
import 'cancelReservationPopUp2.dart';

// ignore: must_be_immutable
class CancleReservAlertPopUp extends StatelessWidget {
  BookingModel bookingModel;
  CancleReservAlertPopUp({required this.bookingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        children: [
          //title text
          const Text(
            'Cancel Reservation',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          //cross button
          Positioned(
            top: 4,
            right: 0,
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: FaIcon(FontAwesomeIcons.x, size: Get.width * 0.05, color: Colors.green,))
          )
        ],
      ),
      content: const Text('Are You Sure You Want To Cancel The Booking?'),
      actions: [
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
              useSafeArea: true,
              isScrollControlled: true,
              context: context, 
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
              ),
              builder: (context){
              return SafeArea(child: CancelReservtionPopUp(bookingModel: bookingModel,));
            });
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.green),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: EdgeInsets.all(Get.width * 0.02),
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
