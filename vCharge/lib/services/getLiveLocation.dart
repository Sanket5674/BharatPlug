import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// This class is named GetLiveLocation
class GetLiveLocation {
// This static method returns a Future of LatLng object, which represents the current location of the user
  static Future<LatLng> getUserLiveLocation() async {
// This boolean variable checks if the location service is enabled on the user's device
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

// If the location service is disabled, then print a message indicating that to the console
    if (!serviceEnabled) {
      //print('Location services are disabled.');
    }

// This variable checks the user's location permission status
    LocationPermission permission = await Geolocator.checkPermission();

// If the user has denied the location permission, then request for the permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // If the user has permanently denied the location permission, then print a message indicating that to the console
      if (permission == LocationPermission.denied) {
        //print('Location permissions are denied.');
      }
    }

// If the user has permanently denied the location permission, then print a message indicating that to the console
    if (permission == LocationPermission.deniedForever) {
      //print('Location permissions are permanently denied.');
    }

// This variable stores the current position of the user
    Position position = await Geolocator.getCurrentPosition();

// This returns the LatLng object which represents the current location of the user
    return LatLng(position.latitude, position.longitude);
  }
}
