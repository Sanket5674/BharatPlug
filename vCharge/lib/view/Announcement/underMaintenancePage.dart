import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnderMaintenance extends StatefulWidget {
  const UnderMaintenance({super.key});

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Under Maintenance"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.08),
                height: MediaQuery.of(context).size.height * 0.32,
                child: Image.asset('assets/images/Undermaintenances.png'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Text(
                "Under Maintenance",
                style: TextStyle(
                    fontSize: Get.height * 0.025, fontWeight: FontWeight.w500),
              ),
            ),
          ]),
    );
  }
}
