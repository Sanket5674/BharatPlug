// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/services/getLiveLocation.dart';
import 'package:vcharge/services/getMethod.dart';
import 'package:vcharge/view/stationsSpecificDetails/stationsSpecificDetails.dart';
import '../../../services/urls.dart';
import '../../../utils/availabilityColorFunction.dart';
import '../../connectivity_service.dart';
import '../homeScreen.dart';

class BgMap extends StatefulWidget {
  String userId;
  List<RequiredStationDetailsModel> typesOfConnector;
  var vehicleSelected;
  var showAvailableChargersOnly;
  var stationMode;
  var selectedConnectorType;

  BgMap({
    required this.userId,
    required this.typesOfConnector,
    required this.vehicleSelected,
    required this.showAvailableChargersOnly,
    required this.stationMode,
    required this.selectedConnectorType,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BgMapState();
}

class BgMapState extends State<BgMap> with TickerProviderStateMixin {
  var storage = const FlutterSecureStorage();
  late Dio dio;
  String urlTemp = '${Urls().stationUrl}/manageStation/getStationInterface';
  static LatLng? userLocation;
  AnimationController? animationController;
  static MapController mapController = MapController();
  static StreamSubscription? subscription;
  static List<RequiredStationDetailsModel> stationsData = [];
  static List<Marker> markersDetails = [];
  static List<RequiredStationDetailsModel> matchingStations = [];

  final ConnectivityService _connectivityService = ConnectivityService();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    dio = Dio()..interceptors.add(_buildCacheInterceptor());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 10), vsync: this);
  }

  @override
  void dispose() {
    animationController?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No internet connection')));
    }
  }

  DioCacheInterceptor _buildCacheInterceptor() {
    return DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        allowPostMethod: true,
        policy: CachePolicy.forceCache,
        maxStale: const Duration(days: 30),
      ),
    );
  }

  static void updateFilters(context, Map<String, dynamic> filters) {
    String? station = filters['stationMode'];
    String? charger = filters['showAvailableChargersOnly'];
    String? chargerType = filters['chargerType'];
    List? connectorType = filters['selectedConnectorType'];

    getFilter(station, charger, chargerType, connectorType);
    BgMapState.getMarkersDetails(context, matchingStations);
  }

  static getFilter(String? stationAccessType, String? chargerAvailability,
      String? chargerType, List? connectorType) {
    matchingStations.clear();
    for (var singleStation in stationsData) {
      if (stationAccessType == singleStation.stationParkingType ||
          stationAccessType == null) {
        for (var singleCharger in singleStation.chargers ?? []) {
          if ((singleCharger.chargerStatus == chargerAvailability ||
              chargerAvailability == null) &&
              (singleCharger.chargerType == chargerType || chargerType == null)) {
            for (var singleConnector in singleCharger.connectors ?? []) {
              if (connectorType == null ||
                  connectorType.contains(singleConnector.connectorType)) {
                checkList(singleStation);
              }
            }
          }
        }
      }
    }
  }

  listTypesOfConnector(List stationList) {
    for (var station in stationList) {
      widget.typesOfConnector.add(station);
    }
  }

  Future<void> getStationData(BuildContext context, String url) async {
    try {
      var data = await GetMethod.getRequest(context, url);
      if (data.isNotEmpty) {
        stationsData.clear();
        for (var item in data) {
          stationsData.add(RequiredStationDetailsModel.fromJson(item));
        }
        if (mounted) {
          BgMapState.getMarkersDetails(context, stationsData);
          listTypesOfConnector(stationsData);
        }
      }
    } catch (_) {}
  }

  static Future<void> getMarkersDetails(
      BuildContext context, List<RequiredStationDetailsModel> data) async {
    try {
      markersDetails = data
          .map(
            (station) => Marker(
          point: LatLng(station.stationLatitude!, station.stationLongitude!),
          alignment: Alignment.center,
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StationsSpecificDetails(
                    stationId: station.stationId!,
                    userId: HomeScreenState.userId,
                  ),
                ),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.locationDot,
              size: 28,
              color:
              AvaliblityColor.getAvailablityColor(station.stationStatus!),
            ),
          ),
        ),
      )
          .toList();
    } catch (_) {}
  }

  Future<void> getLocation() async {
    try {
      var currentLocation = await GetLiveLocation.getUserLiveLocation();
      if (mounted) {
        setState(() {
          userLocation = currentLocation;
        });
      }
      animatedMapMove(userLocation!, 16.0);
    } catch (_) {}
  }

  void animatedMapMove(LatLng dest, double zoom) {
    final latTween = Tween<double>(
        begin: mapController.camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(
        begin: mapController.camera.center.longitude, end: dest.longitude);
    final zoomTween =
    Tween<double>(begin: mapController.camera.zoom, end: zoom);

    final animation =
    CurvedAnimation(parent: animationController!, curve: Curves.easeInOut);

    animationController!.addListener(() {
      mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });

    animationController!.forward(from: 0);
  }

  double getDistance(LatLng latLng1, LatLng latLng2) {
    const R = 6371;
    var dLat = deg2rad(latLng2.latitude - latLng1.latitude);
    var dLon = deg2rad(latLng2.longitude - latLng1.longitude);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(latLng1.latitude)) *
            Math.cos(deg2rad(latLng2.latitude)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  double deg2rad(double deg) => deg * (Math.pi / 180);

  static checkList(RequiredStationDetailsModel station) {
    if (!matchingStations.contains(station)) {
      matchingStations.add(station);
    }
  }

  @override
  Widget build(BuildContext context) {
    getLocation();

    return FutureBuilder<CacheStore>(
      future: _getCacheStore(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cacheStore = snapshot.data!;

        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            minZoom: 3,
            maxZoom: 18,
            initialCenter: userLocation ?? const LatLng(18.52, 73.85),
            initialZoom: 14,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onMapReady: () async {
              await getLocation();
              await getStationData(
                context,
                '${Urls().stationUrl}/manageStation/getStationInterface?longitude=${userLocation?.longitude}&latitude=${userLocation?.latitude}&maxDistance=5000',
              );

              subscription = mapController.mapEventStream.listen((event) {
                if (event is MapEventMoveEnd) {
                  final long = mapController.camera.center.longitude;
                  final lat = mapController.camera.center.latitude;
                  final dist = getDistance(
                      mapController.camera.visibleBounds.northEast,
                      mapController.camera.visibleBounds.southWest) *
                      1000;
                  getStationData(
                      context,
                      '${Urls().stationUrl}/manageStation/getStationsLocation?longitude=$long&latitude=$lat&maxDistance=$dist');
                }
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
              tileProvider: CachedTileProvider(
                maxStale: const Duration(days: 30),
                store: cacheStore,
              ),
            ),
            MarkerLayer(markers: [
              Marker(
                point: userLocation ?? const LatLng(18.5623, 73.9381),
                alignment: Alignment.center,
                width: 40,
                height: 40,
                child: FaIcon(
                  FontAwesomeIcons.locationCrosshairs,
                  color: Colors.green,
                  size: Get.width * 0.05,
                ),
              ),
              ...markersDetails,
            ]),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                alignment: Alignment.center,
                maxZoom: 18,
                markers: [
                  for (final marker in BgMapState.markersDetails) marker,
                ],
                builder: (context, markers) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();
    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }
}
