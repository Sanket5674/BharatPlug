import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/urls.dart';
import 'ResetPasswordScreen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;

  VerifyOtpScreen({required this.phoneNumber, required this.email});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
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

  Future<String> verifyOtpViaPhone(String phoneNumber, int otp) async {
    final response = await http.get(
      Uri.parse(
        '${Urls().securityUrl}/auth/user/forgetPassword/verifyOtp?phoneNumber=$phoneNumber&otp=$otp',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to verify OTP via phone");
    }
  }

  Future<String> verifyOtpViaEmail(String email, int otp) async {
    final response = await http.get(
      Uri.parse(
        '${Urls().securityUrl}/auth/user/forgetPassword/verifyEmailOtp?email=$email&otp=$otp',
      ),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to verify OTP via email");
    }
  }

  Future<void> verifyOtpRequest() async {
    try {
      String enteredOtp =
          otpControllers.map((controller) => controller.text).join();

      String response;
      if (widget.phoneNumber.isEmpty) {
        response = await verifyOtpViaEmail(widget.email, int.parse(enteredOtp));
      } else if (widget.email.isEmpty) {
        response =
            await verifyOtpViaPhone(widget.phoneNumber, int.parse(enteredOtp));
      } else {
        response = await verifyOtpViaEmail(widget.email, int.parse(enteredOtp));
      }

      final status = jsonDecode(response)["status"];

      if (status == "verified") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(
              phoneNumber: widget.phoneNumber,
              email: widget.email,
              otp: int.parse(enteredOtp),
            ),
          ),
        );
      } else if (status == "userExists") {
        // Handle user exists case
      } else if (status == "invalid") {
        setState(() {
          _otpErrorMessage = 'Invalid OTP. Please try again.';
        });
      } else {
        // Handle other statuses as needed
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print("Error: $e");
    }
  }

  // void navigateToLoginScreen() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => AdditionalDetailsScreen(
  //         phoneNumber: widget.phoneNumber,
  //       ),
  //     ),
  //   );
  // }

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
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enter the Verification code we have sent to ",
                                      style: TextStyle(
                                          color: Colors.amber, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.phoneNumber.isNotEmpty)
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
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
                                                controller:
                                                    otpControllers[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                textAlign: TextAlign.center,
                                                maxLength: 1,
                                                decoration: InputDecoration(
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
                                    style: TextStyle(
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
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                  ),
                                  onPressed: verifyOtpRequest,
                                  child: Text(
                                    'Next',
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
                                        // Resend code logic here
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
            )));
  }
}
