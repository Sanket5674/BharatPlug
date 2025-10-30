import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/services/urls.dart';
import 'package:vcharge/utils/availabilityColorFunction.dart';
import 'package:vcharge/view/stationsSpecificDetails/stationsSpecificDetails.dart';

import '../../models/stationModel.dart';

// ignore: must_be_immutable
class FavoriteScreen extends StatefulWidget {
  String userId;
  FavoriteScreen({required this.userId, super.key});

  @override
  State<StatefulWidget> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteStationDetailsModel> favoriteList = [];
  bool isFavorite = false;
  bool isLoading = true;
  Future<void> getFavouriteList() async {
    try {
      const storage = FlutterSecureStorage();
      final userId = await storage.read(key: 'userId');
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getFavoritesByUserId?userId=$userId');
      favoriteList.clear();
      if (data != null && data.isNotEmpty) {
        setState(() {
          for (int i = 0; i < data.length; i++) {
            favoriteList.add(FavoriteStationDetailsModel.fromJson(data[i]));
          }
        });
      }
    } catch (e) {
      //print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFavouriteList();
    Future.delayed(Duration(seconds: 10), () {
      if (isLoading) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Favorites'),
            ),
            body: isLoading
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                        color: Colors.green, size: 40),
                  )
                : favoriteList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Lottie.asset('assets/images/NoData.json'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: favoriteList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StationsSpecificDetails(
                                            userId: widget.userId,
                                            stationId:
                                                favoriteList[index].stationId ??
                                                    "",
                                            isFavoriteadded: () {
                                              getFavouriteList();
                                            },
                                          )));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 5,
                              margin: EdgeInsets.symmetric(
                                  vertical: Get.width * 0.02,
                                  horizontal: Get.width * 0.04),
                              color: const Color.fromARGB(255, 246, 249, 252),
                              child: Padding(
                                  padding: EdgeInsets.all(Get.width * 0.01),
                                  child: Padding(
                                    padding: EdgeInsets.all(Get.width * 0.02),
                                    child: Row(children: [
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //station Name
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Get.height * 0.002),
                                              child: Text(
                                                favoriteList[index]
                                                        .stationName ??
                                                    "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        Get.width * 0.045),
                                              ),
                                            ),

                                            //station address
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Get.height * 0.008),
                                              child: Text(
                                                favoriteList[index]
                                                        .stationArea ??
                                                    "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 132, 132, 132)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //Column for station Status and number of chargers
                                      Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              //station status
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.008),
                                                child: CircleAvatar(
                                                  radius: 8,
                                                  backgroundColor: AvaliblityColor
                                                      .getAvailablityColor(
                                                          favoriteList[index]
                                                                  .stationStatus ??
                                                              ""),
                                                ),
                                              ),

                                              //station number of chargers
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.008),
                                                child: const Text(
                                                  'Chargers: 2/3',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          )),
                                      const Padding(
                                        padding:
                                            EdgeInsets.only(top: 1, bottom: 60),
                                        child: Icon(Icons.favorite,
                                            color: Colors.red),
                                      )
                                    ]),
                                  )),
                            ),
                          );
                        },
                      )));
  }
}
