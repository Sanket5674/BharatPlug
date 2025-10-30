import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Route'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset('assets/images/ComingSoon.json'),
                ),
                // Image.asset(
                //   "assets/images/comingsoon.png",
                // ),
              ],
            ),
          )),
    );
  }
}
