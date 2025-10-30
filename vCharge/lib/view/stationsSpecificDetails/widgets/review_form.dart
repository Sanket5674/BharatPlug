import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/services/GetMethod.dart';
import '../../../services/urls.dart';

// ignore: must_be_immutable
class ReviewForm extends StatefulWidget {
  String? stationId;

  ReviewForm({required this.stationId, String? stationName});

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  int userRating = 0;
  StationModel? stationDetails;
  TextEditingController feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStationDetails();
  }

  Future<void> submitReview() async {
    if (userRating == 0 || feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text("Please Select the star for rating and give feedback ")),
      );
    }
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('userRating_${widget.stationId}_${userId}', userRating);
    //print("User Rating is:$userRating");
    Map<String, String> reviewData = {
      "feedbackCustomerId": userId!,
      "feedbackStationId": widget.stationId!,
      "feedbackText": feedbackController.text,
      "feedbackRating": userRating.toString(),
    };

    try {
      var response = await http.post(
        Uri.parse('${Urls().feedbackUrl}/manageFeedback/addFeedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 200) {
        final snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Your feedback submitted successfully",
            style: TextStyle(color: Colors.white),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context, userRating);
      } else {
        //print('Failed to add review. Status code: ${response.statusCode}');
      }
    } catch (error) {
      //print('Error adding review: $error');
    }
  }

  Future<void> getStationDetails() async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().stationUrl}/manageStation/getStation?stationId=${widget.stationId}');
      //print(widget.stationId);
      setState(() {
        stationDetails = StationModel.fromJson(data);
      });
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Rate the Station'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.01),
                height: MediaQuery.of(context).size.height * 0.250,
                width: MediaQuery.of(context).size.width * 0.500,
                child: SvgPicture.asset('assets/images/feedback.svg'),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  stationDetails?.stationName ?? '',
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      stationDetails?.stationArea ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                ],
              ),
              const Divider(
                color: Colors.black26,
              ),
              Card(
                margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                color: Colors.green, //const Color.fromARGB(255, 162, 241, 165),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: Text(
                              'Your overall rating for this ?',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 1; i <= 5; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        userRating = i;
                                      });
                                    },
                                    child: Icon(
                                      Icons.star,
                                      size: 40.0,
                                      color: i <= userRating
                                          ? Colors.orange
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  'Please tell us about your experience:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: feedbackController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green, style: BorderStyle.solid)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  onPressed: submitReview,
                  label: const Text(
                    'Submit',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
