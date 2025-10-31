import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vcharge/models/supportModel.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/view/helpSupportScreen/supportSpecificScreen.dart';
import '../../services/urls.dart';
import '../connectivity_service.dart';

// ignore: must_be_immutable
class TicketHistoryScreen extends StatefulWidget {
  String userId;

  TicketHistoryScreen({super.key, required this.userId});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  final ConnectivityService _connectivityService = ConnectivityService();
  List<SupportModel> raiseTicketList = [];
  bool isLoading = true;

  @override
  void initState() {
    getAllSupport();
    super.initState();
    _checkConnectivity();
    Future.delayed(Duration(seconds: 10), () {
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
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      final snackBar = SnackBar(
        content: Text('No internet connection'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Return early to avoid the rest of the code
    }
// The rest of your logic (e.g., loading station data) can go here
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAllSupport() async {
    //print("in get all support method");
    try {
      var data = await GetMethod.getRequest(context,
          "${Urls().supportUrl}/manageSupport/getSupportByCustomerId?supportCustomerId=${widget.userId}");
      setState(() {
        if (data.isNotEmpty) {
          for (int i = 0; i < data.length; i++) {
            raiseTicketList.add(SupportModel.fromJson(data[i]));
            //print(SupportModel.fromJson(data[i]));
          }
        } else {
          //print("Empty Data");
        }
      });
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  var refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket History"),
        centerTitle: true,
      ),
      body: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.73,
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                    color: Colors.green, size: 40),
              )
            : raiseTicketList.isEmpty
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
                    ),
                  )
                : RefreshIndicator(
                    key: refreshkey,
                    onRefresh: () async {
                      setState(() {
                        getAllSupport();
                        _checkConnectivity();
                      });
                      //print("refresh");
                    },
                    child: ListView.builder(
                        itemCount: raiseTicketList.length,
                        itemBuilder: (context, index) {
                          var data = raiseTicketList[index];
                          String supportSideResponse =
                              data.supportSideResponse.toString();
                          String customerSideResponse =
                              data.customerSideResponse.toString();

                          String status = data.supportStatus.toString();
                          bool isCompleted = (status == 'completed');

                          return Opacity(
                            opacity: isCompleted
                                ? 0.5
                                : 1.0, // Reduce opacity if completed
                            child: Card(
                                elevation: 4,
                                color: const Color.fromARGB(255, 243, 254, 255),
                                margin: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.01),
                                child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SupportSpecificScreen(
                                                    customerId: data
                                                        .supportCustomerId
                                                        .toString(),
                                                    title: data.supportSubject
                                                        .toString(),
                                                    description: data
                                                        .supportDescription
                                                        .toString(),
                                                    supportSideResponse:
                                                        supportSideResponse,
                                                    customerSideResponse:
                                                        customerSideResponse,
                                                  )));
                                    },
                                    title: Text(
                                      data.supportSubject.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04),
                                    ),
                                    subtitle: //container for station address
                                        Text(
                                      data.supportDescription.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: isCompleted
                                        ? const Icon(Icons.done_all)
                                        : const Icon(Icons.more),
                                    leading: //column for 'distance from user' and connector type
                                        const Icon(Icons.call))),
                          );
                        }),
                  ),
      ),
    );
  }
}
