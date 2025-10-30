import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'connectivity_service.dart';

class ConnectivityMessage extends StatefulWidget {
  final Widget child;
  ConnectivityMessage({required this.child});
  @override
  _ConnectivityMessageState createState() => _ConnectivityMessageState();
}

class _ConnectivityMessageState extends State {
  final ConnectivityService connectivityService = ConnectivityService();
  bool isOnline = true;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isOnline = result != ConnectivityResult.none;
      });
    });
  }

  void checkConnectivity() async {
    final connectivityResult = await connectivityService.checkConnectivity();
    setState(() {
      isOnline = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isOnline)
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.red,
              child: Text(
                'No Internet Connection !',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
