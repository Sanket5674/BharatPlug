import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/urls.dart';

// ignore: must_be_immutable
class ChangePasswordScreen extends StatefulWidget {
  String? emailId;
  ChangePasswordScreen({super.key, required this.emailId});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
// variable for displaying the instructions
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? instruction =
      "Verify the email associated with your account and we'll send an email with instructions to reset your password";
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;
  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reset Password text
              Container(
                margin: EdgeInsets.only(top: Get.height * 0.02),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: Get.height * 0.03),
                ),
              ),

              // instruction section
              Container(
                margin: EdgeInsets.only(top: Get.height * 0.01),
                child: Text(
                  '$instruction',
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              // Email Id
              Container(
                margin: EdgeInsets.only(top: Get.height * 0.01),
                child: const Text("Email"),
              ),

              // displaying email id
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: Get.height * 0.01),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 8, bottom: 8),
                        child: Text(widget.emailId.toString()),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: Get.height * 0.01),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Enter Old Password";
                          }
                          return null;
                        },
                        controller: oldPasswordController,
                        obscureText: !_oldPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _oldPasswordVisible = !_oldPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _oldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Old Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: Get.height * 0.01),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Enter New Password";
                          }
                          return null;
                        },
                        controller: newPasswordController,
                        obscureText: !_newPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _newPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'New Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      margin: EdgeInsets.only(top: Get.height * 0.01),
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return "Enter Confirm Password";
                          }
                          return null;
                        },
                        controller: confirmPasswordController,
                        obscureText: !_confirmPasswordVisible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _confirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          hintText: 'Confirm Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16), // Add some vertical space here

              // Send button
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (confirmPasswordController.text ==
                          newPasswordController.text) {
                        changePassword(
                            widget.emailId.toString(),
                            oldPasswordController.text,
                            confirmPasswordController.text);
                      } else {
                        showSnackbar("Password not match");
                      }
                    }

                    // //print("the button is tapped");
                    // showBottomSheet(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return const ConfirmationSuccessPopUp();
                    //     });
                  },
                  child: const Text(
                    "Send Instructions",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> changePassword(
      String email, String oldPassword, String confirmPassword) async {
    try {
      final response = await http.put(
        Uri.parse(
            "${Urls().securityUrl}/auth/user/changePassword?userEmail=${email}&oldPassword=${oldPassword}&newPassword=${confirmPassword}"),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        //print(response);

        if (jsonResponse['status'] == "success") {
          showSnackbar("Password Updated Successfully");
          newPasswordController.text = "";
          oldPasswordController.text = "";
          confirmPasswordController.text = "";
        } else {
          showSnackbar(jsonResponse['status']);
        }
      } else {
        showSnackbar(response.statusCode.toString());
        //print("API call failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print("Error: $e");
    }
  }
}
