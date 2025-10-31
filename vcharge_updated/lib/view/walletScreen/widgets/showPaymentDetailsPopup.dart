// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:vcharge/models/paymentDetailsModel.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/view/helpSupportScreen/helpSupportScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShowPaymentDetailsPopup extends StatefulWidget {
  String? orderId;

  ShowPaymentDetailsPopup(this.orderId, {super.key});

  @override
  _ShowPaymentDetailsPopupState createState() =>
      _ShowPaymentDetailsPopupState();
}

class _ShowPaymentDetailsPopupState extends State<ShowPaymentDetailsPopup> {
  late List<PaymentDetailsModel> paymentDetailsList = [];
  PaymentDetailsModel? paymentDetails;

  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
  }

  void fetchPaymentDetails() async {
    try {
      paymentDetailsList = await fetchPaymentDetailsData(widget.orderId);
      if (paymentDetailsList.isNotEmpty) {
        setState(() {
          paymentDetails = paymentDetailsList.first;
        });
      }
    } catch (e) {
      //print('Error fetching payment details: $e');
    }
  }

  Future<List<PaymentDetailsModel>> fetchPaymentDetailsData(
      String? orderId) async {
    final response = await http.get(
      Uri.parse(
          '${Urls().paymentUrl}/managePayment/getPaymentsByOrderId?orderId=$orderId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> paymentDetailsJson = json.decode(response.body);
      List<PaymentDetailsModel> paymentDetailsList = paymentDetailsJson
          .map((json) => PaymentDetailsModel.fromJson(json))
          .toList();

      for (var paymentDetails in paymentDetailsList) {
        if (paymentDetails.paymentAmount != null) {
          paymentDetails.paymentAmount = paymentDetails.paymentAmount! / 100;
        }
      }

      return paymentDetailsList;
    } else {
      throw Exception('Failed to load payment details');
    }
  }

  String _getTimeFromEpoch(int? epoch) {
    var date = DateTime.fromMillisecondsSinceEpoch(epoch! * 1000);
    String period = (date.hour < 12) ? 'AM' : 'PM';
    int hour = (date.hour > 12) ? date.hour - 12 : date.hour;
    hour = (hour == 0) ? 12 : hour;
    String minute = (date.minute < 10) ? '0${date.minute}' : '${date.minute}';
    return " $hour:$minute $period";
  }

  String _getFormattedDate(int? epoch) {
    var date = DateTime.fromMillisecondsSinceEpoch(epoch! * 1000);
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          const SizedBox(width: 15),
          paymentDetails != null
              ? Center(
            child: Text(
              paymentDetails!.paymentStatus == 'captured'
                  ? 'Transaction Successful'
                  : paymentDetails!.paymentStatus == 'created'
                  ? "Transaction Pending"
                  : 'Transaction Failed',
              style: TextStyle(
                color: paymentDetails!.paymentStatus == 'failed'
                    ? Colors.red
                    : (paymentDetails!.paymentStatus == 'created'
                    ? Colors.deepOrange
                    : Colors.green),
              ),
            ),
          )
              : const Text("Payment Details"),
        ],
      ),
      content: paymentDetailsList.isNotEmpty
          ? Wrap(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (paymentDetails!.paymentStatus == 'created' ||
                          paymentDetails!.paymentStatus == 'failed')
                          ? const Text("Payment to",
                          style:
                          TextStyle(fontWeight: FontWeight.bold))
                          : const Text("Paid to",
                          style:
                          TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          if (paymentDetails!.paymentStatus == 'captured')
                            const Icon(Icons.add,
                                size: 18, color: Colors.green),
                          Icon(
                            Icons.currency_rupee,
                            size: 18,
                            color: paymentDetails!.paymentStatus ==
                                'failed'
                                ? Colors.red
                                : (paymentDetails!.paymentStatus ==
                                'created'
                                ? Colors.black
                                : Colors.green),
                          ),
                          Text(
                            "${paymentDetails?.paymentAmount}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: paymentDetails!.paymentStatus ==
                                  'failed'
                                  ? Colors.red
                                  : (paymentDetails!.paymentStatus ==
                                  'created'
                                  ? Colors.black
                                  : Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 21,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20.0,
                                backgroundImage: AssetImage(
                                    "assets/images/icon.png"),
                              ),
                            ),
                          ),
                          const Text("Bharat Plug Wallet ",
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              " ${_getTimeFromEpoch(paymentDetails!.createdAtEpoch)} on ${_getFormattedDate(paymentDetails!.createdAtEpoch)} ",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 0.2),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    children: [
                      Icon(Icons.view_list_outlined),
                      SizedBox(width: 10),
                      Text("Transfer Details"),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Transaction ID:",
                          style:
                          TextStyle(color: Colors.grey, fontSize: 15)),
                      Text("${paymentDetails?.id}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 10),
                      if (paymentDetails?.paymentUpiDto?.upivpa != null)
                        Text(
                          "Payment From: ${paymentDetails?.paymentUpiDto!.upivpa}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      const SizedBox(height: 10),
                      if (paymentDetails?.paymentMethod != null)
                        Text(
                          "Payment Method: ${paymentDetails!.paymentMethod}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      if (paymentDetails!.paymentStatus == "created")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Wait for some time ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                            LoadingAnimationWidget.progressiveDots( // ✅ fixed spelling
                              color: Colors.black,
                              size: 20,
                            ),
                          ],
                        ),
                      if (paymentDetails!.paymentStatus == 'created')
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info_outline,
                                      color: Colors.red),
                                  Text(
                                    "If amount credited from your account, ",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 10),
                                  ),
                                ],
                              ),
                              Text(
                                "will be refunded soon",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 10),
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
                const Divider(thickness: 0.2),
                InkWell(
                  onTap: () async {
                    const storage = FlutterSecureStorage();
                    String userId =
                        (await storage.read(key: 'userId')) ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HelpSupportScreen(userId: userId),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.question_answer_outlined,
                            color: Colors.green),
                        SizedBox(width: 5),
                        Text("Contact BharatPlug Support",
                            style: TextStyle(fontSize: 12)),
                        SizedBox(width: 5),
                        Icon(Icons.keyboard_arrow_right,
                            color: Colors.green),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : LoadingAnimationWidget.hexagonDots(
        color: Colors.green,
        size: 40,
      ),
    );
  }
}
