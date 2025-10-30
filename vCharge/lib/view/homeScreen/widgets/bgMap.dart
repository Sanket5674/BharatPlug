// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as Math;
import 'package:latlong2/latlong.dart';
import 'package:vcharge/models/stationModel.dart';
import 'package:vcharge/services/getLiveLocation.dart';
import 'package:vcharge/services/getMethod.dart';
import 'package:vcharge/view/stationsSpecificDetails/stationsSpecificDetails.dart';
import '../../../services/urls.dart';
import '../../../utils/availabilityColorFunction.dart';
import '../../connectivity_service.dart';
import '../homeScreen.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
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
  var storage = FlutterSecureStorage();
  late Dio dio;
  String url_temp = '${Urls().stationUrl}/manageStation/getStationInterface';
  static LatLng? userLocation;
  AnimationController? animationController;
  static MapController mapController = MapController();
  static StreamSubscription? subscription;
  static List<RequiredStationDetailsModel> stationsData = [];
  static List<Marker> markersDetails = [];
  static List<RequiredStationDetailsModel> matchingStations = [];

  static void updateFilters(context, Map<String, dynamic> filters) {
    // print("stationData : ${stationsData.length}");
    String? station = filters['stationMode']; //
    String? charger = filters['showAvailableChargersOnly']; //
    String? chargerType = filters['chargerType']; //
    List? connectorType = filters['selectedConnectorType']; //
    // matchingStations.clear();

    getFilter(station, charger, chargerType, connectorType);

    BgMapState.getMarkersDetails(context, matchingStations);
  }

  static getFilter(String? stationAccessType, String? chargerAvailability,
      String? chargerType, List? connectorType) {
    //print("testing data  ========== $stationAccessType $chargerAvailability $chargerType $connectorType");
    matchingStations.clear();
    stationsData.forEach((singleStation) {
      if (stationAccessType == singleStation.stationParkingType ||
          stationAccessType == null) {
        singleStation.chargers!.length != 0
            ? singleStation.chargers!.forEach((singleCharger) {
                if ((singleCharger.chargerStatus == chargerAvailability ||
                        chargerAvailability == null) &&
                    (singleCharger.chargerType == chargerType ||
                        chargerType == null)) {
                  singleCharger.connectors!.length != 0
                      ? singleCharger.connectors!.forEach((singleConnector) {
                          connectorType != null
                              ? connectorType.forEach((type) {
                                  if ((singleConnector.connectorType == type) ||
                                      type == null) {
                                    // print(" if wale  stationParkingType : ${singleStation.stationParkingType} chargerStatus : ${singleCharger.chargerStatus}  chargerType : ${singleCharger.chargerType}"); //connectorType : ${singleConnector.connectorType} ");
                                    // matchingStations.add(singleStation);
                                    checkList(singleStation);
                                  }
                                })
                              : connectorType == null
                                  ? checkList(singleStation)
                                  : print(
                                      ""); // matchingStations.add(singleStation)
                        })
                      : connectorType == null
                          ? checkList(singleStation)
                          : print("");
                }
              })
            : chargerAvailability == null &&
                    chargerType == null &&
                    connectorType == null
                ? checkList(singleStation)
                : print("");
      }
    });

    //print("matchingStations : ${matchingStations.length}");
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    dio = Dio()..interceptors.add(_buildCacheInterceptor());
    animationController = AnimationController(
        duration: const Duration(milliseconds: 10), vsync: this);
  }

  final ConnectivityService _connectivityService = ConnectivityService();
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
                child: const Text('Retry'),
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

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  listTypesOfConnector(stationList) {
    for (int j = 0; j < stationList.length; j++) {
      widget.typesOfConnector.add(stationList[j]);
    }
  }

  Future<void> getStationData(BuildContext context, String url) async {
    try {
      var data = await GetMethod.getRequest(context, url);
      // print(url);
      // print('the station list is:${data.length}');
      if (data.isNotEmpty) {
        stationsData.clear();
        for (int i = 0; i < data.length; i++) {
          stationsData.add(RequiredStationDetailsModel.fromJson(data[i]));
        }
        if (mounted) {
          BgMapState.getMarkersDetails(context, stationsData);
          listTypesOfConnector(stationsData);
        }
      } else {}
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      // print(e);
    }
  }

  static Future<void> getMarkersDetails(BuildContext context,
      List<RequiredStationDetailsModel> stationsData) async {
    try {
      markersDetails = stationsData.map((idx) {
        return Marker(
          anchorPos: AnchorPos.align(AnchorAlign.center),
          point: LatLng(idx.stationLatitude!, idx.stationLongitude!),
          builder: (ctx) => Semantics(
            label: "StationMarker",
            hint: "Redirect you to specific details of that station",
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StationsSpecificDetails(
                            stationId: idx.stationId!,
                            userId: HomeScreenState.userId,
                          )));
            },
            child: FaIcon(
              FontAwesomeIcons.locationDot,
              size: 30,
              color: AvaliblityColor.getAvailablityColor(idx.stationStatus!),
            ),
          ),
        );
      }).toList();
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  Future<void> getLocation() async {
    try {
      var userLat;
      var userLong;

      if (userLat != null && userLong != null) {
        // BgMapState.userLocation =
        //     LatLng(double.parse(userLat), double.parse(userLong));
        var currentLocation = await GetLiveLocation.getUserLiveLocation();
        if (currentLocation.latitude != userLat &&
            currentLocation.longitude != userLong) {
          if (mounted) {
            setState(() {
              BgMapState.userLocation = currentLocation;
            });
          }
        }
      } else {
        BgMapState.userLocation = await GetLiveLocation.getUserLiveLocation();

        // await RedisConnection.set(
        //     'userLatitude', BgMapState.userLocation!.latitude.toString());
        // await RedisConnection.set(
        //     'userLongitude', BgMapState.userLocation!.longitude.toString());
      }

      if (mounted) {
        animatedMapMove(BgMapState.userLocation!, 20.0);
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //  print(e);
    }
  }

  void animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(
        begin: BgMapState.mapController.camera.center.latitude,
        end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: BgMapState.mapController.camera.center.longitude,
        end: destLocation.longitude);
    final zoomTween = Tween<double>(
        begin: BgMapState.mapController.camera.zoom, end: destZoom);

    final Animation<double> animation =
        CurvedAnimation(parent: animationController!, curve: Curves.easeInOut);

    animationController!.addListener(() {
      if (mounted) {
        setState(() {
          BgMapState.mapController.move(
              LatLng(
                  latTween.evaluate(animation), lngTween.evaluate(animation)),
              zoomTween.evaluate(animation));
        });
      }
    });

    animationController!.forward();
  }

  double getDistance(LatLng latLng1, LatLng latLng2) {
    double lat1 = latLng1.latitude;
    double lon1 = latLng1.longitude;
    double lat2 = latLng2.latitude;
    double lon2 = latLng2.longitude;

    var R = 6371;
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(deg2rad(lat1)) *
            Math.cos(deg2rad(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    var d = R * c;
    return d;
  }

  double deg2rad(deg) {
    return deg * (Math.pi / 180);
  }

  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  final Future<CacheStore> _cacheStoreFuture = _getCacheStore();
  static Future<CacheStore> _getCacheStore() async {
    final dir = await getTemporaryDirectory();
    // Note, that Platform.pathSeparator from dart:io does not work on web,
    // import it from dart:html instead.
    return FileCacheStore('${dir.path}${Platform.pathSeparator}MapTiles');
  }

  setCache(cacheStore) async {
    await storage.write(key: 'cacheStore', value: cacheStore.toString());
  }

  Future getCache() async {
    return (await storage.read(key: 'cacheStore'))!;
  }

  @override
  Widget build(BuildContext context) {
    getLocation();
    return FutureBuilder<CacheStore>(
      future: _cacheStoreFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final cacheStore = snapshot.data!;
          setCache(cacheStore);
          return FlutterMap(
            mapController: BgMapState.mapController,
            options: MapOptions(
              minZoom: 3,
              maxZoom: 17.0,
              initialCenter: BgMapState.userLocation ??
                  LatLng(18.52545104572047, 73.85416186008594),
              initialZoom: 15.0,
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              onMapReady: () async {
                await getLocation();
                if (mounted) {
                  setState(() {
                    getStationData(context,
                        '${Urls().stationUrl}/manageStation/getStationInterface?longitude=${BgMapState.userLocation!.longitude}&latitude=${BgMapState.userLocation!.latitude}&maxDistance=5000');
                  });
                }
                subscription =
                    mapController.mapEventStream.listen((MapEvent mapEvent) {
                  if (mapEvent is MapEventMoveEnd) {
                    double long =
                        BgMapState.mapController.camera.center.longitude;
                    double lat =
                        BgMapState.mapController.camera.center.latitude;
                    double dist = getDistance(
                            BgMapState
                                .mapController.camera.visibleBounds.northEast,
                            BgMapState
                                .mapController.camera.visibleBounds.southWest) *
                        1000;
                    getStationData(context,
                        '${Urls().stationUrl}/manageStation/getStationsLocation?longitude=$long&latitude=$lat&maxDistance=$dist');
                  }
                });
              },
            ),
            children: [
              //tile layer
              TileLayer(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
                tileProvider: CachedTileProvider(
                  maxStale: const Duration(days: 30),
                  store: cacheStore,
                  interceptors: [
                    LogInterceptor(
                      logPrint: (object) {
                        // print("this is type: ${cacheStore.runtimeType}");
                        // print('this is object ${object.toString()}');
                      },
                    ),
                  ],
                ),
                additionalOptions: const {
                  'accessToken':
                      'pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
                  'id': 'mapbox.satellite',
                  'hiveBoxName': 'HiveCacheStoreVCharge',
                },
              ),
              // location marker
              MarkerLayer(
                markers: [
                  //user location marker
                  Marker(
                    anchorPos: AnchorPos.align(AnchorAlign.center),
                    point: BgMapState.userLocation ??
                        const LatLng(18.562323835185673, 73.93812780854178),
                    builder: (ctx) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.locationCrosshairs,
                        color: Colors.green,
                        size: Get.width * 0.05,
                      ),
                    ),
                  ),
                ],
              ),

              //cluster layer
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  anchor: AnchorPos.align(AnchorAlign.center),
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                    maxZoom: 18,
                  ),
                  markers: [
                    //Station markers
                    for (final marker in BgMapState.markersDetails) marker
                  ],
                  builder: (context, markers) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return FlutterMap(
          mapController: BgMapState.mapController,
          options: MapOptions(
            minZoom: 3,
            maxZoom: 17.0,
            initialCenter: BgMapState.userLocation ??
                LatLng(18.52545104572047, 73.85416186008594),
            initialZoom: 15.0,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            onMapReady: () async {
              await getLocation();
              if (mounted) {
                setState(() {
                  getStationData(context,
                      '${Urls().stationUrl}/manageStation/getStationInterface?longitude=${BgMapState.userLocation!.longitude}&latitude=${BgMapState.userLocation!.latitude}&maxDistance=5000');
                });
              }
              subscription =
                  mapController.mapEventStream.listen((MapEvent mapEvent) {
                if (mapEvent is MapEventMoveEnd) {
                  double long =
                      BgMapState.mapController.camera.center.longitude;
                  double lat = BgMapState.mapController.camera.center.latitude;
                  double dist = getDistance(
                          BgMapState
                              .mapController.camera.visibleBounds.northEast,
                          BgMapState
                              .mapController.camera.visibleBounds.southWest) *
                      1000;
                  getStationData(context,
                      '${Urls().stationUrl}/manageStation/getStationsLocation?longitude=$long&latitude=$lat&maxDistance=$dist');
                }
              });
            },
          ),
          children: [
            //tile layer
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
              tileProvider: CachedTileProvider(
                maxStale: const Duration(days: 30),
                store: FileCacheStore(getCache().toString()),
                interceptors: [
                  LogInterceptor(
                    logPrint: (object) {
                      // print("this is type in no data: ${FileCacheStore(getCache().toString()).runtimeType}");
                      // print('this is object ${object.toString()}');
                    },
                  ),
                ],
              ),
              additionalOptions: const {
                'accessToken':
                    'pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
                'id': 'mapbox.satellite',
                'hiveBoxName': 'HiveCacheStoreVCharge',
              },
            ),
            // location marker
            MarkerLayer(
              markers: [
                //user location marker
                Marker(
                  anchorPos: AnchorPos.align(AnchorAlign.center),
                  point: BgMapState.userLocation ??
                      const LatLng(18.562323835185673, 73.93812780854178),
                  builder: (ctx) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.locationCrosshairs,
                      color: Colors.green,
                      size: Get.width * 0.05,
                    ),
                  ),
                ),
              ],
            ),

            //cluster layer
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 45,
                size: const Size(40, 40),
                anchor: AnchorPos.align(AnchorAlign.center),
                fitBoundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                  maxZoom: 18,
                ),
                markers: [
                  //Station markers
                  for (final marker in BgMapState.markersDetails) marker
                ],
                builder: (context, markers) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
    // return FlutterMap(
    //   mapController: BgMapState.mapController,
    //   options: MapOptions(
    //     minZoom: 3,
    //     maxZoom: 17.0,
    //     initialCenter: BgMapState.userLocation ??
    //         LatLng(18.52545104572047, 73.85416186008594),
    //     initialZoom: 15.0,
    //     interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
    //     onMapReady: () async {
    //       await getLocation();
    //       if (mounted) {
    //         setState(() {
    //           getStationData(context,
    //               '${Urls().baseUrl}8096/manageStation/getStationInterface?longitude=${BgMapState.userLocation!.longitude}&latitude=${BgMapState.userLocation!.latitude}&maxDistance=5000');
    //         });
    //       }
    //       subscription =
    //           mapController.mapEventStream.listen((MapEvent mapEvent) {
    //         if (mapEvent is MapEventMoveEnd) {
    //           double long = BgMapState.mapController.camera.center.longitude;
    //           double lat = BgMapState.mapController.camera.center.latitude;
    //           double dist = getDistance(
    //                   BgMapState.mapController.camera.visibleBounds.northEast,
    //                   BgMapState.mapController.camera.visibleBounds.southWest) *
    //               1000;
    //           getStationData(context,
    //               '${Urls().baseUrl}8096/manageStation/getStationsLocation?longitude=$long&latitude=$lat&maxDistance=$dist');
    //         }
    //       });
    //     },
    //   ),
    //   children: [
    //     //tile layer
    //     TileLayer(
    //       urlTemplate:
    //           'https://api.mapbox.com/styles/v1/mapbox/outdoors-v12/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
    //       tileProvider: CachedTileProvider(
    //         maxStale: const Duration(days: 30),
    //         store: _cacheStore,
    //         interceptors: [
    //           LogInterceptor(
    //             logPrint: (object) {
    //               print('this is object ${object.toString()}');
    //               },
    //           ),
    //         ],
    //       ),
    //       additionalOptions: const {
    //         'accessToken':
    //             'pk.eyJ1IjoiYXRoYXJ2YTcwIiwiYSI6ImNsZjk3cTUxZDJjc2czems3N2F3d2Y2aWUifQ._j3hKxoBC_Gnh4-qddn8lg',
    //         'id': 'mapbox.satellite',
    //         'hiveBoxName': 'HiveCacheStoreVCharge',
    //       },
    //     ),
    //     // location marker
    //     MarkerLayer(
    //       markers: [
    //         //user location marker
    //         Marker(
    //           anchorPos: AnchorPos.align(AnchorAlign.center),
    //           point: BgMapState.userLocation ??
    //               const LatLng(18.562323835185673, 73.93812780854178),
    //           builder: (ctx) => Container(
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(100),
    //             ),
    //           ),
    //           child: Center(
    //             child: FaIcon(
    //               FontAwesomeIcons.locationCrosshairs,
    //               color: Colors.green,
    //               size: Get.width * 0.05,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //
    //     //cluster layer
    //     MarkerClusterLayerWidget(
    //       options: MarkerClusterLayerOptions(
    //         maxClusterRadius: 45,
    //         size: const Size(40, 40),
    //         anchor: AnchorPos.align(AnchorAlign.center),
    //         fitBoundsOptions: const FitBoundsOptions(
    //           padding: EdgeInsets.all(50),
    //           maxZoom: 18,
    //         ),
    //         markers: [
    //           //Station markers
    //           for (final marker in BgMapState.markersDetails) marker
    //         ],
    //         builder: (context, markers) {
    //           return Card(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12)),
    //             elevation: 5,
    //             color: Colors.green,
    //             child: Center(
    //               child: Text(
    //                 markers.length.toString(),
    //                 style: const TextStyle(
    //                     color: Colors.white, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }

  static checkList(RequiredStationDetailsModel singleStation) {
    matchingStations.length != 0
        ? matchingStations.addIf(
            !matchingStations.contains(singleStation), singleStation)
        : matchingStations.add(singleStation);
  }
}
