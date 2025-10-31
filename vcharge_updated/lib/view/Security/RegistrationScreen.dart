import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/view/Security/LoginScreen.dart';
import 'package:vcharge/view/Security/VerifyOtpScreen.dart';
import 'package:vcharge/view/privacy/policyScreen.dart';

import '../../services/urls.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void sendOtpRequest() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = phoneNumberController.text;
      try {
        final response = await http.get(
          Uri.parse(
            "${Urls().securityUrl}/auth/registerUser/sendOtp?phoneNumber=$phoneNumber",
          ),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);

          String status = jsonResponse["status"];

          if (status == "userExists") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("User with this phone number already exists."),
              ),
            );
          } else if (status == "sent") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("OTP has been sent successfully."),
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VerifyOtpScreen(
                  phoneNumber: phoneNumber,
                ),
                settings: RouteSettings(arguments: phoneNumber),
              ),
            );
          } else if (status == "alreadySent") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "OTP has already been sent recently. Please check your messages.",
                ),
              ),
            );
          } else if (status == "wait") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please wait before requesting another OTP."),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("An unexpected error occurred."),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text("Request failed with status: ${response.statusCode}"),
            ),
          );
        }
      } catch (e) {
        // showSnackbar("${Components().something_want_wrong}");
      }
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.black12, Colors.transparent],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 100, right: 20, left: 20, bottom: 5),
                    child: Image(image: AssetImage('assets/images/logo.png')),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50, right: 10, left: 10),
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
                              "Let's Get Started !",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Center(
                              child: Text(
                                "Enter your phone number in order to send you your OTP security code",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Form(
                              key: _formKey,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                padding: const EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 24,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: phoneNumberController,
                                        decoration: const InputDecoration(
                                          prefixText: "+91",
                                          labelText: 'Contact Number',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a phone number';
                                          } else if (value.length != 10 ||
                                              !value
                                                  .trim()
                                                  .replaceAll(
                                                      RegExp(r'\s+'), '')
                                                  .contains(
                                                      RegExp(r'^[0-9]*$'))) {
                                            return 'Please enter a valid 10-digit phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already Have an Account? ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return LoginScreen();
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "Login !",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            )),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 110,
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                                onPressed: sendOtpRequest,
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: const Row(children: <Widget>[
                              Expanded(
                                  child: Divider(
                                indent: 50,
                                endIndent: 20,
                                color: Colors.white,
                                thickness: 1,
                              )),
                              Text(
                                "OR",
                                style: TextStyle(color: Colors.white),
                              ),
                              Expanded(
                                  child: Divider(
                                indent: 20,
                                endIndent: 50,
                                color: Colors.white,
                                thickness: 1,
                              )),
                            ])),
                            const SizedBox(height: 13),
                            const Text(
                              "Continue With ",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Container(
                              width: Get.width * 0.6,
                              height: Get.height * 0.05,
                              margin: EdgeInsets.only(
                                  top: Get.height * 0.02,
                                  left: Get.width * 0.06),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: Get.width * 0.07,
                                    margin: EdgeInsets.only(
                                        right: Get.width * 0.04),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                            "assets/images/google.png")),
                                  ),
                                  Container(
                                    width: Get.width * 0.09,
                                    margin: EdgeInsets.only(
                                        right: Get.width * 0.04),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                            "assets/images/facebook.png")),
                                  ),
                                  Container(
                                    width: Get.width * 0.09,
                                    margin: EdgeInsets.only(
                                        right: Get.width * 0.04),
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: Image.asset(
                                            "assets/images/apple.png")),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "I Accept the ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return PolicyScreen(
                                          title: '',
                                        );
                                      },
                                    ));
                                  },
                                  child: const Text(
                                    "Terms & Conditions",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
