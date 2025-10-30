// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vcharge/models/userDataModel.dart';
//import 'package:vcharge/models/userDetailsModel.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/services/urls.dart';
import 'dart:convert';

import '../connectivity_service.dart';

// ignore: must_be_immutable
class AddMoneyScreen extends StatefulWidget {
  String? userId;
  final VoidCallback? onTransactionSuccess;
  final VoidCallback? onTransaction;
  final VoidCallback? onTransactionFailed;
  AddMoneyScreen(
      {required this.userId,
      this.onTransactionSuccess,
      this.onTransaction,
      this.onTransactionFailed,
      super.key});

  @override
  State<StatefulWidget> createState() => AddMoneyScreenState();
}

class AddMoneyScreenState extends State<AddMoneyScreen> {
  //this amount is initial amount in text field
  bool isButtonDisabled = false;
  String initialAmount = "1000";
  final ConnectivityService _connectivityService = ConnectivityService();
  UserDataModel? userDetails;
  var amountController = TextEditingController();

  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    amountController.text = initialAmount;
    getUserData();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
    amountController.dispose();
    _checkConnectivity();
  }

  void navigateToWalletScreen() {
    Navigator.of(context).pop();
  }

  Future<void> getUserData() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');
    try {
      var data = await GetMethod.getRequest(context,
          "${Urls().userUrl}/manageUser/getUserByUserId?userId=$userId");

      if (data != null) {
        setState(() {
          userDetails = UserDataModel.fromJson((data));
        });
      }
    } catch (e) {
      //print("the error is: $e");
    }
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text(
                'Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      const snackBar = SnackBar(
        content: Text('No internet connection'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
  }

  void addToAmountController(int amount) {
    setState(() {
      if (amountController.text.isNotEmpty) {
        int addedAmount = int.parse(amountController.text) + amount;
        amountController.text = addedAmount.toString();
      } else {
        amountController.text = amount.toString();
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _addTransactionHistoryItem(
      amountController.text,
      "vCharge",
      "Adding Money to Wallet",
      true,
      response.paymentId!,
    );
    //print("Payment Id is:$response.paymentId");
    navigateToWalletScreen();
    widget.onTransactionSuccess?.call();
    widget.onTransaction?.call();
    showSnackbar("Your Payment is successfully Completed.");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Error: ${response.code} - ${response.message}",
      timeInSecForIosWeb: 4,
    );

    _addTransactionHistoryItem(
      amountController.text,
      "vCharge",
      "Adding Money to Wallet",
      false,
      null,
    );

    showFailedPaymentDialog();
    widget.onTransactionFailed?.call();
  }

  void showFailedPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Failed'),
          content: const Text('Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    setState(() {
      isButtonDisabled = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet: ${response.walletName}", timeInSecForIosWeb: 4);
  }

  void _addTransactionHistoryItem(String amount, String name,
      String description, bool isSuccess, String? orderId) async {
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    final prefs = await SharedPreferences.getInstance();
    final transactionHistoryJson =
        prefs.getStringList('transactionHistory') ?? [];

    transactionHistoryJson.add(json.encode({
      'amount': amount,
      'name': name,
      'description': description,
      'isSuccess': isSuccess,
      'time': formattedTime,
      'orderId': orderId ?? '',
    }));

    await prefs.setStringList('transactionHistory', transactionHistoryJson);
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<String> _createOrder() async {
    const storage = FlutterSecureStorage();
    final userId = await storage.read(key: 'userId');

    if (amountController.text.isEmpty) {
      showSnackbar('Enter a amount');
      setState(() {
        isButtonDisabled = false;
      });
      return Future.error("Amount is empty");
    }
    final int amount = int.tryParse(amountController.text) ?? 0;
    if (amount < 1 || amount > 9999) {
      showSnackbar('Enter a valid amount');
      setState(() {
        isButtonDisabled = false;
      });
      return Future.error('Invalid amount');
    }
    const String currency = 'INR';
    if (currency.isEmpty) {
      return Future.error('Currency cannot be empty');
    }
    if (userId == null || userId.isEmpty) {
      return Future.error('UserId cannot be empty');
    }
    String apiUrl = '${Urls().paymentUrl}/managePayment/createOrder';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
        'amount': int.parse(amountController.text) * 100,
        'currency': currency,
        'userId': userId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    //print("user Id is :$userId");
    if (response.statusCode == 200) {
      final orderResponse = json.decode(response.body);
      return orderResponse['orderId'];
    } else {
      throw Exception('Failed to create Razorpay order');
    }
  }

  void _startPayment(String orderId) {
    const String apiKey = 'rzp_test_plX9IOqVGIS47Q';

    var options = {
      'key': apiKey,
      'amount': int.parse(amountController.text) * 100,
      'order_id': orderId,
      'name': 'Bharat Plug',
      'description': 'Adding Money to Wallet',
      'prefill': {
        'contact': userDetails?.userContactNo,
        'email': userDetails?.userEmail,
      }
    };

    _razorpay?.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('Wallet'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //container for image
                    Container(
                      margin: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: SvgPicture.asset('assets/images/addMoney.svg'),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'Add Money To Wallet',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // container for amount input
                    Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.01,
                          right: MediaQuery.of(context).size.width * 0.01),
                      child: Card(
                        child: Column(
                          children: [
                            //Container for text field
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                child: TextField(
                                  key: const Key('amountTextField'),
                                  controller: amountController,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter Amount',
                                    hintStyle: TextStyle(fontSize: 20),
                                    prefixIcon: Icon(
                                      Icons.currency_rupee,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //Row for buttons which add a specific amount
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //button for add 100
                                  ElevatedButton(
                                      key: const Key('add100Button'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        addToAmountController(100);
                                      },
                                      child: const Text(
                                        '+100',
                                        style: TextStyle(color: Colors.black),
                                      )),

                                  //button for add 500
                                  ElevatedButton(
                                      key: const Key('add500Button'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        addToAmountController(500);
                                      },
                                      child: const Text(
                                        '+500',
                                        style: TextStyle(color: Colors.black),
                                      )),

                                  //button for add 1000
                                  ElevatedButton(
                                      key: const Key('add1000Button'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        addToAmountController(1000);
                                      },
                                      child: const Text(
                                        '+1000',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Proceed to Add Button
                    GestureDetector(
                      onTap: () async {
                        try {
                          if (!isButtonDisabled) {
                            setState(() {
                              isButtonDisabled = true;
                            });

                            String orderId = await _createOrder();

                            _startPayment(orderId);
                          }
                        } catch (e) {
                          //print('Error: $e');
                        }
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.94,
                        child: Card(
                          color: isButtonDisabled
                              ? Colors.grey
                              : const Color.fromARGB(255, 130, 199, 85),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                'Proceed to Add',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.048,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
