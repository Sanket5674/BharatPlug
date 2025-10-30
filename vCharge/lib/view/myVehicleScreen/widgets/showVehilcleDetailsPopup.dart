// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vcharge/services/DeleteMethod.dart';
import 'package:vcharge/services/urls.dart';

import '../../../models/addVehicleModel.dart';

class ShowVehicleDetailsPopup extends StatelessWidget {
  //Initialize the VehicleModel object
  final AddVehicleModel vehicleDetails;
  final Function onDelete;

  const ShowVehicleDetailsPopup({
    Key? key,
    required this.vehicleDetails,
    required this.onDelete,
  }) : super(key: key);

  Future<void> deleteVehicleData(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this vehicle?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                const storage = FlutterSecureStorage();
                final userId = await storage.read(key: 'userId');
                try {
                  await DeleteMethod.deleteRequest(context,
                      '${Urls().userUrl}/manageUser/removeVehicle?userId=$userId&vehicleId=${vehicleDetails.vehicleId}');
                  // Call the onDelete callback to update the list in MyVehicleScreen
                  onDelete(vehicleDetails);
                } catch (e) {
                  //print(e);
                }

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //GestureDetector for back button
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const CircleAvatar(
                  radius: 15,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            ),
            Container(
                child: Text(
              '${vehicleDetails.vehicleBrandName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              textAlign: TextAlign.end,
            )),

            GestureDetector(
                onTap: () {
                  deleteVehicleData(context);
                },
                child: const CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 246, 249, 252),
                    radius: 15,
                    child: Icon(Icons.delete, color: Colors.red))),
          ],
        ),
      ),
      content: Wrap(
        children: [
          Center(
            child: SizedBox(
                child: vehicleDetails.vehicleType == "2 Wheeler"
                    ? Image.asset("assets/images/2wheeler.png")
                    : vehicleDetails.vehicleType == "3 Wheeler"
                        ? Image.asset("assets/images/3wheeler.png")
                        : Image.asset("assets/images/4wheeler.png")),
          ),

          const SizedBox(
            height: 10,
            width: 1,
          ),
          //Container for Brand Name
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //We have added expanded in text because, if text get renderFlow error, so expanded can adjust it
                const Expanded(
                  child: Text(
                    'Vehicle Model  :',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                    child: Text(
                  '${vehicleDetails.vehicleModelName} ',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
          ),

          //Container for Vehicle Name
          Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //We have added expanded in text because, if text get renderFlow error, so expanded can adjust it
                const Expanded(
                  child: Text(
                    'Vehicle Class  :',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Expanded(
                    child: Text(
                  ' ${vehicleDetails.vehicleClass}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ))
              ],
            ),
          ),

          //Container for Battery Capacity
          if (vehicleDetails.vehicleConnectorType != null)
            Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //We have added expanded in text because, if text get renderFlow error, so expanded can adjust it
                  const Expanded(
                    child: Text(
                      'Connector Type',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    '${vehicleDetails.vehicleConnectorType}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ))
                ],
              ),
            ),
          //Container for Battery Capacity
          if (vehicleDetails.vehicleBatteryCapacity != null)
            Container(
              margin:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //We have added expanded in text because, if text get renderFlow error, so expanded can adjust it
                  const Expanded(
                    child: Text(
                      'Battery Capacity',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  Expanded(
                      child: Text(
                    '${vehicleDetails.vehicleBatteryCapacity}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    textAlign: TextAlign.end,
                  ))
                ],
              ),
            ),

          const SizedBox(
            width: 1,
            height: 10,
          ),
        ],
      ),
    );
  }
}
