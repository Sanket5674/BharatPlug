import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../services/urls.dart';
import 'package:vcharge/view/homeScreen/homeScreen.dart';

class LoginWithOTP extends StatefulWidget {
  final String phoneNumber;

  LoginWithOTP({required this.phoneNumber});

  @override
  _LoginWithOTPState createState() => _LoginWithOTPState();
}

class _LoginWithOTPState extends State<LoginWithOTP> {
  List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final storage = FlutterSecureStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _otpErrorMessage = '';

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
        // print("this is User ID :${userId}");
      } else {
        //print("Error : ${response.statusCode.toString()}");
        return "Error";
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      // showSnackbar("${Components().something_want_wrong}");
    }
  }

  Future<void> verifyOtpRequest(String phoneNumber, String otp) async {
    final otp = otpControllers.map((controller) => controller.text).join();

    final requestBody = {
      'phoneNumber': widget.phoneNumber,
      'otp': otp,
    };

    final requestBodyJson = json.encode(requestBody);

    final url = Uri.parse('${Urls().securityUrl}/auth/loginUser/verifyOtp');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('token')) {
          final String token = data['token'];
          //await storage.write(key: 'authToken', value: token);
          getUserId(token);
          //  print("response for otp: ${response.body}");
          // Login contactNumberLogin = Login(phoneNumber, otp);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) {
              //print("Successfully logged in with contact number");
              return HomeScreen(
                  // login: contactNumberLogin,
                  );
            },
          ), (route) => false);
        } else if (data['status'] == 'invalid') {
          setState(() {
            _otpErrorMessage = 'Invalid OTP. Please try again.';
          });
        } else {
          showSnackbar('An error occurred. Please try again later.');
        }
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
                            "Enter the verification code",
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
                                  "Enter the Verification code we have send to ",
                                  style: TextStyle(
                                      color: Colors.amber, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "(+91) ${widget.phoneNumber}",
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: SingleChildScrollView(
                              child: Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        4,
                                        (index) => SizedBox(
                                          width: 40,
                                          child: TextFormField(
                                            controller: otpControllers[index],
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            decoration: const InputDecoration(
                                              counterText: "",
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.amber,
                                                    width: 2),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              if (value.isNotEmpty &&
                                                  index < 3) {
                                                FocusScope.of(context)
                                                    .nextFocus();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_otpErrorMessage.isNotEmpty)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _otpErrorMessage,
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
                            width: 110,
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                              onPressed: () {
                                verifyOtpRequest(
                                    widget.phoneNumber,
                                    otpControllers
                                        .map((controller) => controller.text)
                                        .join());
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't Receive Anything ? ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (BuildContext context) {
                                    //     return AdditionalDetailsScreen(
                                    //       phoneNumber: widget.phoneNumber,
                                    //     );
                                    //   },
                                    // ));
                                  },
                                  child: Text(
                                    "Resend Code ",
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 16,
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
