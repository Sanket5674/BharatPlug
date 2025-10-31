import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/bookingModel.dart';
import '../../../services/PutMethod.dart';
import '../../../services/urls.dart';
import 'cancellationDonePopUp.dart';

// ignore: must_be_immutable
class CancelReservtionPopUp extends StatefulWidget {
  BookingModel bookingModel;
  CancelReservtionPopUp({required this.bookingModel, super.key});

  @override
  State<CancelReservtionPopUp> createState() => CancelReservtionPopUpState();
}

class CancelReservtionPopUpState extends State<CancelReservtionPopUp> {
  BookingModel? bookingModel;

  TextEditingController additionInfo = TextEditingController();

  var cancelReasonsList = [
    'Time Issue',
    'Change of Plans',
    'Technical Issue',
    'Other'
  ];

  // ignore: prefer_typing_uninitialized_variables
  var selectedReason;

  final formKeyReason = GlobalKey<FormState>();
  final formKeyAddInfo = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bookingModel = widget.bookingModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //"Booking Details" Heading text
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 113, 174, 76),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cancel Reservation',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.height * 0.025),
            ),
          )),
        ),

        //select reason dropdown
        Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: Get.height * 0.01),
            child: Form(
              key: formKeyReason,
              child: DropdownButtonFormField(
                hint: const Text('Select a Reason'),
                value: selectedReason,
                decoration: const InputDecoration(
                    label: Text("Select Reason"), border: OutlineInputBorder()),
                isExpanded: true,
                items: cancelReasonsList
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedReason = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a reason';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),

        // Addition info text field
        Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: Get.height * 0.01),
            child: Form(
              key: formKeyAddInfo,
              child: TextFormField(
                controller: additionInfo,
                maxLength: 150,
                maxLines: 5,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  hintText: 'Additional Info',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please give some additional info";
                  }
                  return null;
                },
              ),
            ),
          ),
        ),

        //Submit button
        ElevatedButton(
            onPressed: () async {
              if (formKeyReason.currentState!.validate() &&
                  formKeyAddInfo.currentState!.validate()) {
                try {
                  var response = await PutMethod.putRequest(
                      '${Urls().bookingUrl}/manageBooking/cancelledBooking?bookingId=',
                      bookingModel!.bookingId!,
                      jsonEncode({
                        "bookingCancellationReason":
                            "$selectedReason ${additionInfo.text.toString()}}",
                        "bookingStatus": "cancelled"
                      }));
                  if (response == 200) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return const CancellationDonePopUp();
                        });
                  }
                } catch (e) {
                  // Components().showSnackbar(Components().something_want_wrong, context);
                  //print(e);
                }
              }
            },
            child: const Text('Submit')),
      ],
    );
  }
}
