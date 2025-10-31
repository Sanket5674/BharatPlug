import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:vcharge/view/homeScreen/widgets/bgMap.dart';
import '../../../services/getLiveLocation.dart';

class LocationFinder extends StatefulWidget {
  final VoidCallback updateState;
  const LocationFinder({required this.updateState, super.key});

  @override
  State<LocationFinder> createState() => LocationFinderState();
}

class LocationFinderState extends State<LocationFinder>
    with TickerProviderStateMixin {
  bool locationFinder = false;

  Future<void> getToUserLocation() async {
    try {
      setState(() => locationFinder = true);

      // Get current GPS coordinates
      LatLng currLocation = await GetLiveLocation.getUserLiveLocation();
      BgMapState.userLocation = currLocation;

      // Animate to user's location
      animatedMapMove(BgMapState.userLocation!, 20.0);

      setState(() => locationFinder = false);
    } catch (e) {
      // Optional: showSnackbar("Something went wrong", context);
      setState(() => locationFinder = false);
    }
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    // Use new Flutter Map 8.x camera properties
    final latTween = Tween<double>(
      begin: BgMapState.mapController.camera.center.latitude,
      end: destLocation.latitude,
    );
    final lngTween = Tween<double>(
      begin: BgMapState.mapController.camera.center.longitude,
      end: destLocation.longitude,
    );
    final zoomTween = Tween<double>(
      begin: BgMapState.mapController.camera.zoom,
      end: destZoom,
    );

    final controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );

    controller.addListener(() {
      BgMapState.mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "locationFinder",
      child: InkWell(
        onTap: () async => await getToUserLocation(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          margin: const EdgeInsets.only(right: 13, bottom: 10),
          child: CircleAvatar(
            backgroundColor:
            locationFinder ? Colors.transparent : Colors.green,
            child: locationFinder
                ? const CircularProgressIndicator(color: Colors.green)
                : const FaIcon(
              FontAwesomeIcons.locationCrosshairs,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
