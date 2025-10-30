import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/urls.dart';
import '../components.dart';
import 'EmailPasswordScreen.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final String phoneNumber;

  AdditionalDetailsScreen({required this.phoneNumber});

  @override
  _AdditionalDetailsScreenState createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  Future<void> updateUserDetails(String firstName, String lastName) async {
    String apiUrl =
        "${Urls().securityUrl}/auth/registerUser/updateUserFirstNameAndLastName?userContactNo=${widget.phoneNumber}";

    Map<String, dynamic> requestBody = {
      "userFirstName": firstName,
      "userLastName": lastName,
    };

    String requestBodyJson = json.encode(requestBody);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EmailPasswordScreen(
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      } else {
        //print("API call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.black12, Colors.transparent]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100, right: 20, left: 20),
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50, right: 10, left: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black45,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Share More Details",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 110,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              onPressed: () {
                                String firstName = firstNameController.text;
                                String lastName = lastNameController.text;
                                if (firstName.isEmpty || lastName.isEmpty) {
                                  Components().showSnackbar(
                                      "Please Enter both First Name and Last Name",
                                      context);
                                } else {
                                  updateUserDetails(firstName, lastName);
                                }
                              },
                              child: Text(
                                'Next',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
