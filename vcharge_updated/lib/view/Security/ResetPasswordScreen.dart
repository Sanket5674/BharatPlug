// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/view/Security/LoginScreen.dart';
import '../../services/urls.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final int otp;

  ResetPasswordScreen(
      {required this.phoneNumber, required this.email, required this.otp});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final storage = FlutterSecureStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _passwordErrorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> resetPasswordByContactNo(
      String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      setState(() {
        _passwordErrorMessage = 'Passwords do not match.';
      });
      return;
    }

    final authToken = await storage.read(key: 'authToken');

    final requestBody = {
      'password': newPassword,
    };

    final requestBodyJson = json.encode(requestBody);

    final url = Uri.parse(
        '${Urls().securityUrl}/auth/user/forgetPassword/updatePasswordByContactNo?phoneNumber=${widget.phoneNumber}&otp=${widget.otp}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // Password reset successful, navigate to the home screen
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginScreen();
          },
        ));
      } else {
        showSnackbar('An error occurred. Please try again later.');
      }
    } catch (e) {
      showSnackbar('An error occurred. Please check your internet connection.');
    }
  }

  Future<void> resetPasswordByEmail(
      String newPassword, String confirmPassword) async {
    if (newPassword != confirmPassword) {
      setState(() {
        _passwordErrorMessage = 'Passwords do not match.';
      });
      return;
    }

    final authToken = await storage.read(key: 'authToken');

    final requestBody = {
      'password': newPassword,
    };

    final requestBodyJson = json.encode(requestBody);

    final url = Uri.parse(
        '${Urls().securityUrl}/auth/user/forgetPassword/updatePasswordByEmail?email=${widget.email}&otp=${widget.otp}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) {
            return LoginScreen();
          },
        ));
      } else {
        showSnackbar('An error occurred. Please try again later.');
      }
    } catch (e) {
      showSnackbar('An error occurred. Please check your internet connection.');
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
          key: _scaffoldKey,
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
                            "Reset Your Password",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Please enter your new password",
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 16),
                                ),
                              ],
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
                              controller: _newPasswordController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
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
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                            ),
                          ),
                          if (_passwordErrorMessage.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _passwordErrorMessage,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 150,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              onPressed: () {
                                if (widget.phoneNumber == null) {
                                  // Reset password by contact number
                                  resetPasswordByEmail(
                                    _newPasswordController.text,
                                    _confirmPasswordController.text,
                                  );
                                } else if (widget.email == null) {
                                  // Reset password by email
                                  resetPasswordByContactNo(
                                    _newPasswordController.text,
                                    _confirmPasswordController.text,
                                  );
                                } else {
                                  resetPasswordByEmail(
                                    _newPasswordController.text,
                                    _confirmPasswordController.text,
                                  );
                                }
                              },
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
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
