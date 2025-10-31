// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcharge/view/helpSupportScreen/helpSupportScreen.dart';
import 'package:vcharge/view/privacy/policyScreen.dart';
import 'package:vcharge/view/reservationsScreen/reservationScreen.dart';
import 'package:vcharge/view/walletScreen/walletScreen.dart';
import 'package:vcharge/view/myVehicleScreen/myVehicleScreen.dart';

import '../../route/RouteScreen.dart';

// ignore: must_be_immutable
class HorizontalSideBar extends StatefulWidget {
  String userId;

  HorizontalSideBar({required this.userId, super.key});

  @override
  State<HorizontalSideBar> createState() => HorizontalSideBarState();
}

class HorizontalSideBarState extends State<HorizontalSideBar> {
// boolean variables used for adding the texture effect to the respective buttons
  bool isVehicle = false;
  bool isMapRoute = false;
  bool isWallet = false;
  bool isFavourite = false;
  bool isReservation = false;
  bool isMore = false;

// boolean variable for more side panel
  bool isMoreSidePaneOpen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.height * 0.009),
        child: Row(
          children: [
            // container - vehicle addition
            GestureDetector(
              key: const Key('MyVehicle'),
              onTap: () {
                setState(() {
                  isVehicle = true;
                });
                Future.delayed(const Duration(seconds: 1)).then((_) {
                  setState(() {
                    isVehicle = false;
                  });
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyVehicleScreen(
                              userId: widget.userId,
                            )));
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: Get.width * 0.03, right: Get.width * 0.01),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: isMapRoute ? Colors.white : Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.car,
                        size: 20,
                        color: Color.fromARGB(255, 51, 50, 50),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'My vehicle',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // container - my wallet
            GestureDetector(
              key: const Key('myWallet'),
              onTap: () {
                setState(() {
                  isWallet = true;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WalletScreen(
                          userId: widget.userId,
                        )));
                Future.delayed(const Duration(seconds: 1)).then((_) {
                  setState(() {
                    isWallet = false;
                  });
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                decoration: BoxDecoration(
                  // border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: isWallet ? Colors.white : Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.wallet, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      const Text(
                        'Wallet',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // container - Route
            GestureDetector(
              key: const Key('Route'),
              onTap: () {
                setState(() {
                  isMapRoute = true;
                });
                Future.delayed(const Duration(seconds: 1)).then((_) {
                  setState(() {
                    isMapRoute = false;
                  });
                });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RouteScreen()
                      ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                decoration: BoxDecoration(
                  // border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: isMapRoute ? Colors.white : Colors.white,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.route,
                        size: 20,
                        color: Color.fromARGB(255, 51, 50, 50),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Route',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // container - reservations
            GestureDetector(
              key: const Key('Reservation'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => //UpcomingScreen()
                            ReservationScreen(
                              userId: widget.userId,
                            )
                    ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                decoration: BoxDecoration(
                    // border: Border.all(),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: isReservation
                        ? const Color.fromARGB(255, 115, 204, 43)
                        : Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.book_online, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      const Text(
                        'Reservations',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // container - more optionsPage
            GestureDetector(
              key: const Key('moreOptions'),
              onTapDown: (TapDownDetails details) {
                showPopupMenu(context, details.globalPosition);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                decoration: BoxDecoration(
                  // border: Border.all(),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: isMore
                      ? const Color.fromARGB(255, 115, 204, 43)
                      : Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz_sharp, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      const Text(
                        'More',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //function to pop more options
  void showPopupMenu(BuildContext context, Offset position) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final selectedMenuItem = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Blogs & Videos'),
              Icon(
                Icons.video_collection,
                color: Colors.green,
              )
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Help & Support'),
              Icon(Icons.contact_support, color: Colors.green)
            ],
          ),
        ),
        const PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User Manual'),
              Icon(Icons.library_books, color: Colors.green)
            ],
          ),
        ),
        const PopupMenuItem(
          value: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Legal Policy'),
              Icon(Icons.policy_rounded, color: Colors.green)
            ],
          ),
        ),
        const PopupMenuItem(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              Icon(Icons.logout_rounded, color: Colors.red)
            ],
          ),
        ),
      ],
      elevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    // Handle the selected menu item
    if (selectedMenuItem != null) {
      switch (selectedMenuItem) {
        case 1:
          const websiteUrl = 'https://virtuososofttech.com/our-blogs/';
          if (await canLaunchUrl(Uri.parse(websiteUrl))) {
            await launchUrl(Uri.parse(websiteUrl));
          } else {
            throw 'Could not launch $websiteUrl';
          }
          break;
        case 2:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HelpSupportScreen(
                        userId: widget.userId,
                      )));
          break;
        case 3:
          break;
        case 4:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PolicyScreen(title: "Privacy Polices")));
          break;
      }
    }
  }
}
