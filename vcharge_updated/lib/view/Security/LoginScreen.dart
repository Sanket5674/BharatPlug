import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vcharge/view/Security/LoginWithOTP.dart';
import 'package:vcharge/view/homeScreen/homeScreen.dart';
import 'package:vcharge/view/Security/forgotPassword.dart';

import '../../services/urls.dart';
import 'RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _contactNumberOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = FlutterSecureStorage();
  final client = http.Client();
  bool _passwordVisible = false;
  bool _isNumericInput = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _contactNumberOrEmailController.addListener(() {
      final text = _contactNumberOrEmailController.text;

      setState(() {
        _isNumericInput = isNumeric(text);
      });
    });
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isNumeric(String str) {
    return double.tryParse(str) != null;
  }

  Future getUserId(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${Urls().securityUrl}/auth/extractUserFromToken'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        //print(" res :${response.body}");
        var uid = jsonDecode(response.body);
        String userId = uid['userId'];
        await storage.write(key: 'userId', value: userId);
        final SharedPreferences userid = await SharedPreferences.getInstance();
        await userid.setString('userId', '${userId}');
        //print("this is User ID :${userId}");
      } else {
        //print("this is User Id : ${response.statusCode.toString()}");
        return "Error";
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      // showSnackbar("${Components().something_want_wrong}");
    }
  }

  Future<void> loginUser(String contactNumber, String password) async {
    final requestBody = {
      'userName': contactNumber,
      'password': password,
    };

    final requestBodyJson = json.encode(requestBody);

    //print('Request Body: $requestBodyJson');
    try {
      final response = await http.post(
        Uri.parse(
            '${Urls().securityUrl}/auth/loginUser/ByContactNoAndPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        //print('Received status code: 200 (OK)');

        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('token')) {
          final String token = data['token'];
          //print(token);

          await storage.write(key: 'authToken', value: token);
          getUserId(token);
          Login contactNumberLogin = Login(contactNumber, password);
          getUserId(token);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) {
              //print("Successfully logged in with contact number");
              return HomeScreen(
                login: contactNumberLogin,
              );
            },
          ), (route) => false);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //   builder: (BuildContext context) {
          //     //print("Successfully logged in with contact number");
          //     return HomeScreen(
          //       login: contactNumberLogin,
          //     );
          //   },
          // ));
        } else if (data['status'] == 'userNotExists') {
          showSnackbar('User does not exist. Please register.');
        } else if (data['status'] == 'invalid') {
          showSnackbar('Invalid username or password. Please try again.');
        } else {
          showSnackbar('An error occurred. Please try again later.');
        }
      } else {
        showSnackbar('An error occurred. Please try again later.');
      }
    } catch (e) {
      // showSnackbar("${Components().something_want_wrong}");
    }
  }

  Future<void> loginU(String email, String password) async {
    final requestBody = {
      'userName': email,
      'password': password,
    };

    final requestBodyJson = json.encode(requestBody);

    //print('Request Body: $requestBodyJson');

    try {
      final response = await http.post(
        Uri.parse('${Urls().securityUrl}/auth/loginUser/ByEmailAndPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        //print('Received status code: 200 (OK)');

        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('token')) {
          final String token = data['token'];
          //print(token);

          await storage.write(key: 'authToken', value: token);

          Login emailLogin = Login(email, password);
          getUserId(token);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) {
              //print("Successfully logged in with contact number");
              return HomeScreen(
                login: emailLogin,
              );
            },
          ), (route) => false);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //   builder: (BuildContext context) {
          //     //print("Successfully logged in with email");
          //     return HomeScreen(
          //       login: emailLogin,
          //     );
          //   },
          // ));
        } else if (data['status'] == 'userNotExists') {
          showSnackbar('User does not exist. Please register.');
        } else if (data['status'] == 'invalid') {
          showSnackbar('Invalid username or password. Please try again.');
        } else {
          showSnackbar('An error occurred. Please try again later.');
        }
      } else {
        showSnackbar('An error occurred. Please try again later.');
      }
    } catch (e) {
      //showSnackbar("${Components().something_want_wrong}");
    }
  }

  Future<void> sendOtpRequest(String phoneNumber) async {
    try {
      final url = Uri.parse(
          '${Urls().securityUrl}/auth/loginUser/sentOtp?phoneNumber=$phoneNumber');

      final response = await http.get(url);

      //print(response);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final status = data['status'];

        if (status == 'sent') {
          //print(status);
          // Only navigate to LoginWithOTP screen when status is "sent"
          navigateToLoginWithOTP(phoneNumber);
        } else if (status == 'alreadySent') {
          // OTP already sent
          showSnackbar('alreadySent');
        } else if (status == 'wait') {
          // Waiting for OTP
          showSnackbar('wait');
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
    } catch (e) {
      //showSnackbar("${Components().something_want_wrong}");
    }
  }

  void navigateToLoginWithOTP(String phoneNumber) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginWithOTP(phoneNumber: phoneNumber),
      ),
    );
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
                    colors: [Colors.black12, Colors.transparent])),
            child: Scaffold(
              key: _scaffoldKey,
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
                      margin: EdgeInsets.only(top: 50, right: 10, left: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.black45,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Welcome Back !",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Please Login to continue our App",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Container(
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
                                        controller:
                                            _contactNumberOrEmailController,
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
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size:
                                          24, // Adjust the size to your preferred value
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _passwordController,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        obscureText: !_passwordVisible,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return ForgotPasswordScreen(); // Replace with the actual class name
                                      },
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 110,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final input =
                                                _contactNumberOrEmailController
                                                    .text;
                                            if (input.isEmpty) {
                                              // Show an error message since the input is empty
                                              showSnackbar(
                                                  'Please enter a phone number');
                                            } else if (input.length != 10 ||
                                                !input
                                                    .trim()
                                                    .replaceAll(
                                                        RegExp(r'\s+'), '')
                                                    .contains(
                                                        RegExp(r'^[0-9]*$'))) {
                                              // Show an error message for an invalid phone number
                                              showSnackbar(
                                                  'Please enter a valid 10-digit phone number');
                                            } else {
                                              // Phone number is valid, proceed with sending OTP request
                                              sendOtpRequest(input);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "Request ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "OTP",
                                                style: TextStyle(
                                                  color: Colors.amber,
                                                  fontSize: 15,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                  ),
                                  onPressed: () {
                                    final input =
                                        _contactNumberOrEmailController.text;
                                    final password = _passwordController.text;

                                    if (input.contains('@')) {
                                      loginU(input, password);
                                    } else {
                                      loginUser(input, password);
                                    }
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
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
                              ])),
                              SizedBox(height: 13),
                              Text(
                                "Continue With ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
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
                                    // facebook icon
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

                                    // twitter icon
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
                                          .pushReplacement(MaterialPageRoute(
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
                              ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
