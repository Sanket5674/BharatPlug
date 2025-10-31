import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/view/Security/LoginScreen.dart';

import '../../services/urls.dart';
import '../components.dart';

class EmailPasswordScreen extends StatefulWidget {
  final String phoneNumber;

  const EmailPasswordScreen({super.key, required this.phoneNumber});

  @override
  _EmailPasswordScreenState createState() => _EmailPasswordScreenState();
}

class _EmailPasswordScreenState extends State<EmailPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool emailExists = false;

  Future<void> updateEmailAndPassword(String email, String password) async {
    String apiUrl =
        "${Urls().securityUrl}/auth/registerUser/updateEmailAndPassword?userContactNo=${widget.phoneNumber}";

    Map<String, dynamic> requestBody = {
      "userEmail": email,
      "password": password,
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //print(response);

        if (jsonResponse['status'] == "success") {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) {
              return LoginScreen();
            },
          ), (route) => false);
        } else if (jsonResponse['status'] == "exists") {
          setState(() {
            emailExists = true;
          });
        } else {
          //print("API call failed with status: ${jsonResponse['status']}");
          Components().showSnackbar("Please Enter a valid Email", context);
        }
      } else {
        //print("API call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
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
        decoration: const BoxDecoration(
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
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: emailExists
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          if (emailExists)
                            const Text(
                              'Email already exists',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          const SizedBox(
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
                                String email = emailController.text;
                                String password = passwordController.text;
                                if (email.isEmpty || password.isEmpty) {
                                  Components().showSnackbar(
                                      "Please Enter Correct Email and Password",
                                      context);
                                } else {
                                  updateEmailAndPassword(email, password);
                                }
                              },
                              child: const Text(
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
