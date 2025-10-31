import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vcharge/models/chargingHistoryModel.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/view/stationsSpecificDetails/widgets/review_form.dart';

// ignore: must_be_immutable
class ChargingHistoryDetailsPopUp extends StatelessWidget {
  final ChargingHistoryModel transactionDetails;
  final StationModel stationDetails;
  int userRating = 0;

  ChargingHistoryDetailsPopUp({
    required this.transactionDetails,
    required this.stationDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.55,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 113, 174, 76),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  'Charging History Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Get.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
              child: ListTile(
                title: Text(
                  '${stationDetails.stationName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Get.width * 0.05,
                  ),
                ),
                subtitle: stationDetails.stationAddressLineOne == null
                    ? const Text("...")
                    : Text(
                        stationDetails.stationAddressLineTwo!,
                        maxLines: 3,
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Charging ID',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        transactionDetails.transactionId!,
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Charging Status',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        transactionDetails.transactionStatus == "EVDisconnected"
                            ? "Fully charged or Disconnected"
                            : transactionDetails.transactionStatus!,
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Energy Consumption',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "11.3 KW",
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Transaction Amount',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Rs. ${transactionDetails.transactionAmount ?? "No Amount Data Available"}',
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Charging Date',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat("dd MMM, yyyy").format(
                          DateTime.parse(
                              transactionDetails.transactionMeterStartDate!),
                        ),
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Charging Time',
                        style: TextStyle(
                          fontSize: Get.width * 0.04,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        ' ${DateFormat("hh:mm a ").format(DateTime.parse(transactionDetails.transactionMeterStartTimeStamp!))}-${DateFormat(" hh:mm a ").format(DateTime.parse(transactionDetails.transactionMeterStopTimeStamp!))}',
                        style: TextStyle(
                          fontSize: Get.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(
                horizontal: Get.width * 0.01, vertical: Get.height * 0.01),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Would you like to share Your Experience?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewForm(
                                        stationId: stationDetails.stationId,
                                      )),
                            );
                          },
                          child: Icon(
                            size: 19,
                            Icons.star,
                            color: userRating >= index + 1
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
