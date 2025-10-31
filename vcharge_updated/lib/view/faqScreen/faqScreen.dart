// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';

import '../../services/urls.dart';
import '../connectivity_service.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  FaqScreenState createState() => FaqScreenState();
}

class FaqScreenState extends State<FaqScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  String selectedCategory = 'General';
  List<dynamic> faqs = [];
  bool isLoading = true;
  int expandedIndex = -1;

  Future<void> getFaqs() async {
    try {
      var response =
          await http.get(Uri.parse('${Urls().faqsUrl}/manageFaq/getAllFaqs'));
      //  print(response);
      if (response.statusCode == 200) {
        //  print(response.body);
        setState(() {
          faqs = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load FAQs');
      }
    } catch (e) {
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFaqs();
    _checkConnectivity();
    Future.delayed(const Duration(seconds: 10), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  // build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQ"),
        centerTitle: true,
      ),

      // column has two children:
      body: Column(
        children: [
          // toggle buttons - first child
          Container(
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var category in [
                    'General',
                    'Charger',
                    'Payment And Refund',
                    'Troubleshooting And Maintenance'
                  ])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedCategory == category
                              ? Colors.green
                              : Colors.white,
                          side: const BorderSide(
                            color: Colors.green,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // questions and answers - second child
          Expanded(
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.green, size: 40),
                  )
                : faqs.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Lottie.asset('assets/images/NoData.json'),
                          ),
                          const Text(
                            "No Data Available !",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: faqs
                            .where(
                                (faq) => faq['faqCategory'] == selectedCategory)
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          var sortedFaqs;
                          var faq;

                          // block for sorting the specific category faq on the basis of the faq sequence number
                          try {
                            sortedFaqs = faqs
                                .where((faq) =>
                                    faq['faqCategory'] == selectedCategory)
                                .toList()
                              ..sort((faq1, faq2) => faq1['faqSeqNumber']
                                  .compareTo(faq2['faqSeqNumber']));
                            faq = sortedFaqs[index];
                          } catch (e) {
                            // Components().showSnackbar(Components().something_want_wrong, context);
                            //print("The error is in the faq: $e");
                          }

                          return Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                title: Text(faq['faqQuestion']),
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    expandedIndex = expanded ? index : -1;
                                  });
                                },
                                initiallyExpanded: index == expandedIndex,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(faq['faqAnswer']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
