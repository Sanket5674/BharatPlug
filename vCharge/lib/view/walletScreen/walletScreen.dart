// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vcharge/models/CreditsPaymentModel.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:intl/intl.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/view/walletScreen/addMoneyScreen.dart';
import 'package:vcharge/view/walletScreen/widgets/showPaymentDetailsPopup.dart';
import '../../models/transactionModelNew.dart';
import '../../models/walletModel.dart';

// ignore: must_be_immutable
class WalletScreen extends StatefulWidget {
  String? userId;

  WalletScreen({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  // final ConnectivityService _connectivityService = ConnectivityService();

  WalletModel? walletDetail;
  num? walletAmount;
  bool? walletStatus;
  var currentMonth;

  List<CreditsPaymentModel> newCreditPaymentList = [];
  List<CreditsPaymentModel> todayCreditData = [];
  List<CreditsPaymentModel> weekCreditData = [];
  List<CreditsPaymentModel> monthCreditData = [];
  List<CreditsPaymentModel> yearCreditData = [];
  List<TransactionModelNew> newTransactionData = [];
  List<TransactionModelNew> todayTransactionData = [];
  List<TransactionModelNew> weekTransactionData = [];
  List<TransactionModelNew> monthTransactionData = [];
  List<TransactionModelNew> yearTransactionData = [];
  bool credit = true;
  var userFirstName = "...";
  var userLastName = "...";
  int day = 1;
  final storage = const FlutterSecureStorage();
  bool isLoading = true;

  @override
  void initState() {
    getCreditDetails();
    getWalletDetails();
    super.initState();
    if (mounted) {
      Future.delayed(const Duration(seconds: 20), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  //fetch the wallet details according to userId and store it to walletDetail variable
  Future<void> getWalletDetails() async {
    try {
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          "${Urls().userUrl}/manageUser/getWalletByUserId?userId=${userId.toString()}");

      ////print("------$data");

      setState(() {
        walletAmount = data == null ? 0 : data['walletAmount'] / 100;
        walletStatus = data == null ? false : data['active'];
      });

      ////print('------$walletAmount');
    } catch (e) {
      ////print(e);
    }
  }

  void _updateWalletBalance() {
    getWalletDetails();
  }

  void _updateCreditList() {
    getCreditDetails();
  }

  Future<void> getCreditDetails() async {
    try {
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          "${Urls().paymentUrl}/managePayment/getPaymentsByUserId?userId=$userId");
      newCreditPaymentList.clear();
      todayCreditData.clear();
      weekCreditData.clear();
      monthCreditData.clear();
      yearCreditData.clear();

      setState(() {
        if (data != null) {
          for (int i = 0; i < data.length; i++) {
            newCreditPaymentList.add(CreditsPaymentModel(
              id: data[i]['id'],
              paymentAmount: data[i]['paymentAmount'] / 100,
              paymentOrderId: data[i]['paymentOrderId'],
              currency: data[i]['currency'],
              userId: data[i]['userId'],
              createdAt: data[i]['createdAt'],
              userEmail: data[i]['userEmail'],
              userContact: data[i]['userContact'],
              paymentMethod: data[i]['paymentMethod'],
              userAccountCredited: data[i]['userAccountCredited'],
              paymentStatus: data[i]['paymentStatus'],
            ));
          }
          ////print("The Credit List is-----:$newCreditPaymentList");

          var now = DateTime.now();
          var now_1m = DateTime(now.year, now.month - 1, now.day);

          var todayDate = DateFormat('yyyy-MM-dd')
              .format(DateFormat('yyyy-MM-dd').parse("$now"));

          var weekDate =
              DateFormat('yyyy-MM').format(DateFormat('yyyy-MM').parse("$now"));

          currentMonth =
              DateFormat('MMMM, y').format(DateFormat('yyyy-MM').parse("$now"));

          var monthDate =
              DateFormat('yyyy').format(DateFormat('yyyy').parse("$now_1m"));

          for (int i = 0; i < data.length; i++) {
            var dateForCompareToday = DateFormat('yyyy-MM-dd').format(
                DateFormat('yyyy-MM-dd')
                    .parse("${newCreditPaymentList[i].createdAt}"));

            var dateForCompareWeek = DateFormat('yyyy-MM').format(
                DateFormat('yyyy-MM')
                    .parse("${newCreditPaymentList[i].createdAt}"));

            var dateForCompareMonth = DateFormat('yyyy').format(
                DateFormat('yyyy')
                    .parse("${newCreditPaymentList[i].createdAt}"));

            todayDate == dateForCompareToday
                ? todayCreditData.add(newCreditPaymentList[i])
                : weekDate == dateForCompareWeek
                    ? todayCreditData.add(newCreditPaymentList[i])
                    : monthDate == dateForCompareMonth
                        ? monthCreditData.add(newCreditPaymentList[i])
                        : yearCreditData.add(newCreditPaymentList[i]);
          }
        }
      });
      ////print("Today data:$todayCreditData");
    } catch (e) {
      if (kDebugMode) {
        ////print(e);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getTransaction() async {
    try {
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          "${Urls().transactionUrl}/manageTransaction/getTransactionAmounts?transactionCustomerId=$userId");
      newTransactionData.clear();
      todayTransactionData.clear();
      weekTransactionData.clear();
      monthTransactionData.clear();
      yearTransactionData.clear();

      ////print("data : $data");
      setState(() {
        if (data != null) {
          for (int i = 0; i < data.length; i++) {
            newTransactionData.add(TransactionModelNew(
              transactionId: data[i]['transactionId'],
              transactionAmount: data[i]['transactionAmount'] / 100,
              chargerName: data[i]['chargerName'],
              transactionMeterStopTimeStamp: data[i]
                  ['transactionMeterStopTimeStamp'],
            ));
          }

          var now = DateTime.now();
          var now_1m = DateTime(now.year, now.month - 1, now.day);

          var todayDate = DateFormat('yyyy-MM-dd')
              .format(DateFormat('yyyy-MM-dd').parse("$now"));

          var weekDate =
              DateFormat('yyyy-MM').format(DateFormat('yyyy-MM').parse("$now"));

          currentMonth =
              DateFormat('MMMM, y').format(DateFormat('yyyy-MM').parse("$now"));

          var monthDate =
              DateFormat('yyyy').format(DateFormat('yyyy').parse("$now_1m"));

          for (int i = 0; i < data.length; i++) {
            var dateForCompareToday = DateFormat('yyyy-MM-dd').format(
                DateFormat('yyyy-MM-dd').parse(
                    "${newTransactionData[i].transactionMeterStopTimeStamp}"));

            var dateForCompareWeek = DateFormat('yyyy-MM').format(
                DateFormat('yyyy-MM').parse(
                    "${newTransactionData[i].transactionMeterStopTimeStamp}"));

            var dateForCompareMonth = DateFormat('yyyy').format(
                DateFormat('yyyy').parse(
                    "${newTransactionData[i].transactionMeterStopTimeStamp}"));

            todayDate == dateForCompareToday
                ? todayTransactionData.add(newTransactionData[i])
                : weekDate == dateForCompareWeek
                    ? weekTransactionData.add(newTransactionData[i])
                    : monthDate == dateForCompareMonth
                        ? monthTransactionData.add(newTransactionData[i])
                        : yearTransactionData.add(newTransactionData[i]);
          }
        }
      });
    } catch (e) {
      ////print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //this function returns an icon based on given status
  IconData getStatusIcon(String status) {
    if (status.trim().toLowerCase() == 'complete') {
      return Icons.done;
    } else if (status.trim().toLowerCase() == 'pending') {
      return Icons.pending;
    } else {
      return Icons.cancel;
    }
  }

  //this function returns a color based on given status
  MaterialColor getStatusColor(String status) {
    if (status.trim().toLowerCase() == 'completed') {
      return Colors.green;
    } else if (status.trim().toLowerCase() == 'pending') {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                getWalletDetails();
              },
              icon: const Icon(Icons.refresh)),
        ],
        centerTitle: true,
        title: const Text('Wallet'),
      ),
      body: Wrap(
        children: [
          Align(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, bottom: 30, left: 15, right: 15),
              child: Container(
                height: 150,
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 15.0,
                      spreadRadius: -20.0,
                      offset: Offset(0.0, 25.0),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 64, 134, 18),
                      Color.fromARGB(255, 93, 183, 73),
                      Color.fromARGB(255, 113, 186, 68),
                      Color.fromARGB(255, 86, 179, 65),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, right: 8, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Column for available balance
                      Column(
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.normal),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          walletAmount == null
                              ? const Row(
                                  children: [
                                    Icon(Icons.currency_rupee_sharp),
                                    Text(' ',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Icon(Icons.currency_rupee_sharp),
                                    Text('$walletAmount',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold))
                                  ],
                                )
                        ],
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          key: const Key('creditButton'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: Colors.white,
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddMoneyScreen(
                                          userId: widget.userId,
                                          onTransactionSuccess:
                                              _updateWalletBalance,
                                          onTransaction: _updateCreditList,
                                          onTransactionFailed: () {
                                            getCreditDetails();
                                          },
                                        )));
                          },
                          child: const Text(
                            'Add Money',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ),

          //Container for transaction heading
          Container(
            decoration: const BoxDecoration(color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(
                  child: Text(
                'Transactions',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.06),
              )),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              credit
                  ? Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.green),
                        ),
                      ),
                      child: const Center(
                          child: Text("Credit",
                              style: TextStyle(
                                fontSize: 17,
                              ))))
                  : InkWell(
                      onTap: () {
                        setState(() {
                          newTransactionData = [];

                          credit = true;
                        });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: const EdgeInsets.all(8.0),
                          child: const Center(
                              child: Text("Credit",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black))))),
              credit
                  ? InkWell(
                      onTap: () {
                        newTransactionData = [];
                        getTransaction();
                        setState(() {
                          credit = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(8.0),
                        child: const Center(
                          child: Text(
                            "Debit",
                            style: TextStyle(fontSize: 17, color: Colors.black),
                          ),
                        ),
                      ))
                  : Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.green),
                        ),
                      ),
                      child: const Center(
                          child: Text("Debit",
                              style: TextStyle(
                                fontSize: 17,
                              )))),
            ],
          ),

          !credit
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.52,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                  child: isLoading
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: Colors.green, size: 40),
                        )
                      : newTransactionData.isEmpty
                          ? const Center(
                              child: Text(
                                "No Transactions are Done.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: Column(
                                  children: [
                                    //today
                                    if (todayTransactionData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Today",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: todayTransactionData.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                            child: Image.asset(
                                                          "assets/images/debitmoney.png",
                                                        ))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Paid to',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${todayTransactionData[index].chargerName}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MMMM d, yyyy')
                                                            .format(DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(todayTransactionData[
                                                                        index]
                                                                    .transactionMeterStopTimeStamp!)),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.033,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Icon(
                                                              Icons.remove,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .currency_rupee,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              todayTransactionData[
                                                                      index]
                                                                  .transactionAmount!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              const Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),

                                    //week
                                    if (weekTransactionData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$currentMonth",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: weekTransactionData.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                            child: Image.asset(
                                                                "assets/images/debitmoney.png"))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Paid to',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${weekTransactionData[index].chargerName}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MMMM d, yyyy')
                                                            .format(DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(weekTransactionData[
                                                                        index]
                                                                    .transactionMeterStopTimeStamp!)),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.033,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Icon(
                                                              Icons.remove,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .currency_rupee,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              weekTransactionData[
                                                                      index]
                                                                  .transactionAmount!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              const Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),

                                    //month
                                    if (monthTransactionData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Month",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: monthTransactionData.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Center(
                                                              child: Image.asset(
                                                                  "assets/images/debitmoney.png"))),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Paid to',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            // fontWeight: FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${monthTransactionData[index].chargerName}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MMMM d, yyyy')
                                                            .format(DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(monthTransactionData[
                                                                        index]
                                                                    .transactionMeterStopTimeStamp!)),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.033,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Icon(
                                                              Icons.remove,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .currency_rupee,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              monthTransactionData[
                                                                      index]
                                                                  .transactionAmount!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              const Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),
                                    //year
                                    if (yearTransactionData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Year",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: yearTransactionData.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: SizedBox(
                                                        height: 30,
                                                        width: 30,
                                                        child: Center(
                                                            child: Image.asset(
                                                                "assets/images/debitmoney.png"))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Paid to',
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${yearTransactionData[index].chargerName}",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'MMMM d, yyyy')
                                                            .format(DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(yearTransactionData[
                                                                        index]
                                                                    .transactionMeterStopTimeStamp!)),
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.033,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const Icon(
                                                              Icons.remove,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .currency_rupee,
                                                              size: 18,
                                                              color: Colors.red,
                                                            ),
                                                            Text(
                                                              yearTransactionData[
                                                                      index]
                                                                  .transactionAmount!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 18,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              const Divider(
                                                color: Colors.grey,
                                              )
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.52,
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
                  child: isLoading
                      ? Center(
                          child: LoadingAnimationWidget.inkDrop(
                              color: Colors.green, size: 40),
                        )
                      : newCreditPaymentList.isEmpty
                          ? const Center(
                              child: Text(
                                "No Transactions are Done.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topCenter,
                              child: SingleChildScrollView(
                                physics: const ScrollPhysics(),
                                child: Column(
                                  children: [
                                    //today
                                    if (todayCreditData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Today",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),

                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: todayCreditData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return ShowPaymentDetailsPopup(
                                                        todayCreditData[index]
                                                            .paymentOrderId);
                                                  });
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Center(
                                                              child: Image.asset(
                                                                  "assets/images/debitmoney.png"))),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        todayCreditData[index].paymentStatus ==
                                                                                'failed'
                                                                            ? 'Failed '
                                                                            : todayCreditData[index].paymentStatus == 'created'
                                                                                ? 'Pending '
                                                                                : 'Credited to ',
                                                                        style:
                                                                            TextStyle(
                                                                          color: todayCreditData[index].paymentStatus == 'failed' || todayCreditData[index].paymentStatus == 'created'
                                                                              ? Colors.red
                                                                              : Colors.green,
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width * 0.04,
                                                                        ),
                                                                      ),
                                                                      if (todayCreditData[index]
                                                                              .paymentStatus ==
                                                                          'failed')
                                                                        const Icon(
                                                                          Icons
                                                                              .error_outline,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                      if (todayCreditData[index]
                                                                              .paymentStatus ==
                                                                          'created')
                                                                        const Icon(
                                                                          Icons
                                                                              .schedule,
                                                                          color:
                                                                              Colors.red,
                                                                          size:
                                                                              18,
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                            ],
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4.0),
                                                            child: Text(
                                                              "Bharat Plug Wallet",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  'MMMM d, yyyy')
                                                              .format(DateFormat(
                                                                      'yyyy-MM-dd')
                                                                  .parse(todayCreditData[
                                                                          index]
                                                                      .createdAt!)),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.033,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              if (todayCreditData[
                                                                          index]
                                                                      .paymentStatus ==
                                                                  'captured')
                                                                const Icon(
                                                                  Icons.add,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                              Icon(
                                                                Icons
                                                                    .currency_rupee,
                                                                size: 18,
                                                                color: todayCreditData[
                                                                                index]
                                                                            .paymentStatus ==
                                                                        'failed'
                                                                    ? Colors.red
                                                                    : (todayCreditData[index].paymentStatus ==
                                                                            'created'
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .green),
                                                              ),
                                                              Text(
                                                                todayCreditData[
                                                                        index]
                                                                    .paymentAmount!
                                                                    .toStringAsFixed(
                                                                        2),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  color: todayCreditData[index].paymentStatus ==
                                                                          'failed'
                                                                      ? Colors
                                                                          .red
                                                                      : (todayCreditData[index].paymentStatus ==
                                                                              'created'
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .green),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                const Divider(
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          );
                                        }),

                                    //week
                                    if (weekCreditData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "$currentMonth",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: weekCreditData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ShowPaymentDetailsPopup(
                                                          weekCreditData[index]
                                                              .paymentOrderId);
                                                    });
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/images/debitmoney.png"))),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          weekCreditData[index].paymentStatus == 'failed'
                                                                              ? 'Failed '
                                                                              : weekCreditData[index].paymentStatus == 'created'
                                                                                  ? 'Pending '
                                                                                  : 'Credited to ',
                                                                          style:
                                                                              TextStyle(
                                                                            color: weekCreditData[index].paymentStatus == 'failed' || weekCreditData[index].paymentStatus == 'created'
                                                                                ? Colors.red
                                                                                : Colors.green,
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                          ),
                                                                        ),
                                                                        if (weekCreditData[index].paymentStatus ==
                                                                            'failed')
                                                                          const Icon(
                                                                            Icons.error_outline,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                        if (weekCreditData[index].paymentStatus ==
                                                                            'created')
                                                                          const Icon(
                                                                            Icons.schedule,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 4.0),
                                                              child: Text(
                                                                "Bharat Plug Wallet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'MMMM d, yyyy')
                                                                .format(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(weekCreditData[
                                                                            index]
                                                                        .createdAt!)),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.033,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if (weekCreditData[
                                                                            index]
                                                                        .paymentStatus ==
                                                                    'captured')
                                                                  const Icon(
                                                                    Icons.add,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                Icon(
                                                                  Icons
                                                                      .currency_rupee,
                                                                  size: 18,
                                                                  color: weekCreditData[index].paymentStatus ==
                                                                          'failed'
                                                                      ? Colors
                                                                          .red
                                                                      : (weekCreditData[index].paymentStatus ==
                                                                              'created'
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .green),
                                                                ),
                                                                Text(
                                                                  weekCreditData[
                                                                          index]
                                                                      .paymentAmount!
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: weekCreditData[index].paymentStatus ==
                                                                            'failed'
                                                                        ? Colors
                                                                            .red
                                                                        : (weekCreditData[index].paymentStatus ==
                                                                                'created'
                                                                            ? Colors.black
                                                                            : Colors.green),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  const Divider(
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ));
                                        }),
                                    //month
                                    if (monthCreditData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Month",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: monthCreditData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ShowPaymentDetailsPopup(
                                                          monthCreditData[index]
                                                              .paymentOrderId);
                                                    });
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/images/debitmoney.png"))),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          monthCreditData[index].paymentStatus == 'failed'
                                                                              ? 'Failed '
                                                                              : monthCreditData[index].paymentStatus == 'created'
                                                                                  ? 'Pending '
                                                                                  : 'Credited to ',
                                                                          style:
                                                                              TextStyle(
                                                                            color: monthCreditData[index].paymentStatus == 'failed' || monthCreditData[index].paymentStatus == 'created'
                                                                                ? Colors.red
                                                                                : Colors.green,
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                          ),
                                                                        ),
                                                                        if (monthCreditData[index].paymentStatus ==
                                                                            'failed')
                                                                          const Icon(
                                                                            Icons.error_outline,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                        if (monthCreditData[index].paymentStatus ==
                                                                            'created')
                                                                          const Icon(
                                                                            Icons.schedule,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 4.0),
                                                              child: Text(
                                                                "Bharat Plug Wallet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'MMMM d, yyyy')
                                                                .format(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(monthCreditData[
                                                                            index]
                                                                        .createdAt!)),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.033,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if (monthCreditData[
                                                                            index]
                                                                        .paymentStatus ==
                                                                    'captured')
                                                                  const Icon(
                                                                    Icons.add,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                Icon(
                                                                  Icons
                                                                      .currency_rupee,
                                                                  size: 18,
                                                                  color: monthCreditData[index].paymentStatus ==
                                                                          'failed'
                                                                      ? Colors
                                                                          .red
                                                                      : (monthCreditData[index].paymentStatus ==
                                                                              'created'
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .green),
                                                                ),
                                                                Text(
                                                                  monthCreditData[
                                                                          index]
                                                                      .paymentAmount!
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: monthCreditData[index].paymentStatus ==
                                                                            'failed'
                                                                        ? Colors
                                                                            .red
                                                                        : (monthCreditData[index].paymentStatus ==
                                                                                'created'
                                                                            ? Colors.black
                                                                            : Colors.green),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  const Divider(
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ));
                                        }),
                                    //year
                                    if (yearCreditData.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: const Text(
                                            "Year",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        itemCount: yearCreditData.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ShowPaymentDetailsPopup(
                                                          yearCreditData[index]
                                                              .paymentOrderId);
                                                    });
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: SizedBox(
                                                            height: 30,
                                                            width: 30,
                                                            child: Center(
                                                                child: Image.asset(
                                                                    "assets/images/debitmoney.png"))),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          yearCreditData[index].paymentStatus == 'failed'
                                                                              ? 'Failed '
                                                                              : yearCreditData[index].paymentStatus == 'created'
                                                                                  ? 'Pending '
                                                                                  : 'Credited to ',
                                                                          style:
                                                                              TextStyle(
                                                                            color: yearCreditData[index].paymentStatus == 'failed' || yearCreditData[index].paymentStatus == 'created'
                                                                                ? Colors.red
                                                                                : Colors.green,
                                                                            fontSize:
                                                                                MediaQuery.of(context).size.width * 0.04,
                                                                          ),
                                                                        ),
                                                                        if (yearCreditData[index].paymentStatus ==
                                                                            'failed')
                                                                          const Icon(
                                                                            Icons.error_outline,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                        if (yearCreditData[index].paymentStatus ==
                                                                            'created')
                                                                          const Icon(
                                                                            Icons.schedule,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                18,
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                              ],
                                                            ),
                                                            const Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 4.0),
                                                              child: Text(
                                                                "Bharat Plug Wallet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'MMMM d, yyyy')
                                                                .format(DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .parse(yearCreditData[
                                                                            index]
                                                                        .createdAt!)),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.033,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 10.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                if (yearCreditData[
                                                                            index]
                                                                        .paymentStatus ==
                                                                    'captured')
                                                                  const Icon(
                                                                    Icons.add,
                                                                    size: 18,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                Icon(
                                                                  Icons
                                                                      .currency_rupee,
                                                                  size: 18,
                                                                  color: yearCreditData[index].paymentStatus ==
                                                                          'failed'
                                                                      ? Colors
                                                                          .red
                                                                      : (yearCreditData[index].paymentStatus ==
                                                                              'created'
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .green),
                                                                ),
                                                                Text(
                                                                  yearCreditData[
                                                                          index]
                                                                      .paymentAmount!
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: yearCreditData[index].paymentStatus ==
                                                                            'failed'
                                                                        ? Colors
                                                                            .red
                                                                        : (yearCreditData[index].paymentStatus ==
                                                                                'created'
                                                                            ? Colors.black
                                                                            : Colors.green),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  const Divider(
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ));
                                        }),
                                  ],
                                ),
                              ),
                            ),
                ),
        ],
      ),
    );
  }
}
