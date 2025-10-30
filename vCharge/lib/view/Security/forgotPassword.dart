// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/view/Security/ForgotPasswordOTP.dart';
import 'package:vcharge/view/Security/LoginScreen.dart';
import 'package:vcharge/view/Security/RegistrationScreen.dart';

import '../../services/urls.dart';

// ... other imports and code ...

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isNumericInput = false;

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    inputController.addListener(() {
      final text = inputController.text;
      setState(() {
        _isNumericInput = isNumeric(text);
      });
    });
    super.initState();
  }

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  Future<void> sendOtpViaPhoneNumber(String phoneNumber) async {
    final url = Uri.parse(
        '${Urls().securityUrl}/auth/loginUser/sentOtp?phoneNumber=$phoneNumber');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final status = data['status'];

      if (status == 'sent') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              phoneNumber: phoneNumber,
              email: "",
            ),
          ),
        );
      } else if (status == 'alreadySent') {
        // OTP already sent
        showSnackbar('OTP already sent via phone number');
      } else if (status == 'wait') {
        // Waiting for OTP
        showSnackbar('Waiting for OTP via phone number');
      } else if (status == 'notExists') {
        // User does not exist
        showSnackbar('User does not exist. Please register.');
      } else {
        // Handle other error cases here
        showSnackbar('An error occurred. Please try again later.');
      }
    } else {
      // Handle server errors here
      showSnackbar('An error occurred. Please try again later.');
    }
  }

  Future<void> sendOtpViaEmail(String email) async {
    final url = Uri.parse(
        '${Urls().securityUrl}/auth/user/forgetPassword/sentOtpViaEmail?email=$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final status = data['status'];

      if (status == 'sent') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              phoneNumber: " ",
              email: email,
            ),
          ),
        );
      } else if (status == 'alreadySent') {
        // OTP already sent
        showSnackbar('OTP already sent via email');
      } else if (status == 'wait') {
        // Waiting for OTP
        showSnackbar('Waiting for OTP via email');
      } else if (status == 'notExists') {
        // User does not exist
        showSnackbar('User does not exist. Please register.');
      } else {
        // Handle other error cases here
        showSnackbar('An error occurred. Please try again later.');
      }
    } else {
      // Handle server errors here
      showSnackbar('An error occurred. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
            colors: [Colors.black12, Colors.transparent],
          ),
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
                            "Forgot Password ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: const Text(
                              "No worries, we’ll send you reset instructions",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Form(
                            key: _formKey,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 24,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: inputController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Number or Email',
                                        prefixText:
                                            _isNumericInput ? '+91 ' : '',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              final input = inputController.text;
                              if (input.isEmpty) {
                                showSnackbar(
                                    'Please enter your phone number or email');
                              } else {
                                if (_isNumericInput) {
                                  sendOtpViaPhoneNumber(input);
                                } else {
                                  sendOtpViaEmail(input);
                                }
                              }
                            },
                            child: Text('Send OTP',
                                style: TextStyle(color: Colors.black)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't Have an Account? ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return RegistrationScreen();
                                      },
                                    ));
                                  },
                                  child: Text(
                                    "Register !",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(children: const <Widget>[
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
                            ]),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Back To, ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return LoginScreen();
                                      },
                                    ));
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              ],
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
