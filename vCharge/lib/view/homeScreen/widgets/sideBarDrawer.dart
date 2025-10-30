// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vcharge/view/addVehicleScreen/addVehicle.dart';
import 'package:vcharge/view/faqScreen/faqScreen.dart';
import 'package:vcharge/view/settingScreen/settingPage.dart';
import 'package:vcharge/view/helpSupportScreen/helpSupportScreen.dart';
import 'package:vcharge/view/walletScreen/walletScreen.dart';
import '../../../services/GetMethod.dart';
import '../../../services/urls.dart';
import '../../favouriteScreen/favouriteScreen.dart';
import '../../profileScreen/myProfile.dart';
import '../../referFriendScreen/referFriend.dart';
import '../../reservationsScreen/reservationScreen.dart';
import '../../ChargingHistory/chargingSessions.dart';

// ignore: must_be_immutable
class SideBarDrawer extends StatefulWidget {
  String userId;
  final storage = const FlutterSecureStorage();

  SideBarDrawer({super.key, required this.userId});

  @override
  State<SideBarDrawer> createState() => _SideBarDrawerState();
}

class _SideBarDrawerState extends State<SideBarDrawer> {
  // variables for storing the only displaying user details
  String firstName = '';
  String lastName = '';
  String profilePhoto = '';
  String contactNo = '';
  String emailId = '';

  void handleLogout() async {
    final storage = const FlutterSecureStorage();
    await storage.delete(key: 'authToken');
    await storage.delete(key: 'userId');
    await storage.deleteAll();

    Navigator.of(context).pushReplacementNamed(
      '/login',
    );
  }

  Future<void> getUserData() async {
    try {
      String userId;
      const storage = FlutterSecureStorage();
      userId = (await storage.read(key: 'userId'))!;
      //print("userId : $userId");
      var response = await GetMethod.getRequest(context,
          "${Urls().userUrl}/manageUser/getUserByUserId?userId=$userId");

      setState(() {
        response['userProfilePhoto'] == null
            ? profilePhoto = ""
            : profilePhoto = response['userProfilePhoto'];
        firstName = response['userFirstName'];
        lastName = response['userLastName'];
        contactNo = response['userContactNo'];
        emailId = response['userEmail'];
      });
    } catch (e) {
      //print("the error at the redis connection in profile widget is: $e");
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.70,
        child: Semantics(
          label: "drawerButton",
          value: 'drawerButton',
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        child: InkWell(
                          key: const Key('profileButton'),
                          child: profilePhoto == ""
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.black,
                                )
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      MemoryImage(base64Decode(profilePhoto)),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyProfilePage(
                                    userId: widget.userId.toString()),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("$firstName $lastName"),
                      ),
                    ],
                  ),
                ),

                // container - vehicle addition
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const FaIcon(
                            FontAwesomeIcons.car,
                            size: 20,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Add Vehicle'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddVehicleScreen(
                                          userId: widget.userId,
                                        ))).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - wallet
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.wallet,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Wallet'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletScreen(
                                          userId: widget.userId,
                                        ))).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - Sessions
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.event,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Charging History'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChargingHistoryScreen())).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - reservation
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.book_online,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Reservations'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReservationScreen(
                                          userId: widget.userId,
                                        ))).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Container - favourites
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const Icon(
                            Icons.favorite_outline_outlined,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Favorites'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoriteScreen(
                                        userId: widget.userId))).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container for Refer a friend
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          width: 25,
                          height: 25,
                          child: Image.asset("assets/images/referral.png",
                              color: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('Refer a friend'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ReferFriend())).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - FAQ
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child: const Icon(Icons.question_answer,
                              color: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text('FAQs'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FaqScreen())).then((value) {
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            });
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - help and support
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child:
                              const Icon(Icons.headphones, color: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: Semantics(
                          label: "drawerHelpAndSupportButton",
                          child: ListTile(
                            title: const Text('Help & Support'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HelpSupportScreen(
                                            userId: widget.userId,
                                          )));
                              Future.delayed(
                                const Duration(milliseconds: 250),
                              );
                            },
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              size: MediaQuery.of(context).size.width * 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Container - settings page
                Container(
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(width: 0.1))),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Container(
                          decoration: const BoxDecoration(),
                          child:
                              const Icon(Icons.settings, color: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: Semantics(
                          label: "drawerSettingsButton",
                          child: ListTile(
                            title: const Text('Settings'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPage(
                                    userId: widget.userId.toString(),
                                    firstNameEdited: firstName,
                                    lastNameEdited: lastName,
                                    contactNoEdited: contactNo,
                                    emailIdEdited: emailId,
                                  ),
                                ),
                              ).then((value) {
                                Future.delayed(
                                  const Duration(milliseconds: 250),
                                );
                              });
                            },
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              size: MediaQuery.of(context).size.width * 0.07,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // container - logout
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: const BoxDecoration(),
                        child: const Icon(Icons.logout, color: Colors.red),
                      ),
                    ),
                    Expanded(
                      child: Semantics(
                        label: "drawerLogoutButton",
                        child: ListTile(
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {
                            handleLogout();
                          },
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
