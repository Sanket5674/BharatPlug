import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/view/passwordScreen/changePasswordScreen.dart';
import 'package:vcharge/view/privacy/policyScreen.dart';
import 'package:vcharge/view/profileScreen/editProfileScreen.dart';
import '../../services/urls.dart';
import '../connectivity_service.dart';

// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  String userId;
  String? firstNameEdited;
  String? lastNameEdited;
  String? emailIdEdited;
  String? contactNoEdited;

  SettingPage({
    super.key,
    required this.userId,
    required this.firstNameEdited,
    required this.lastNameEdited,
    required this.contactNoEdited,
    required this.emailIdEdited,
  });

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ConnectivityService _connectivityService = ConnectivityService();

  // variable for tracking dark mode status

  String? firstNameEdited;
  String? lastNameEdited;
  String? emailIdEdited;
  String? contactNoEdited;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await _connectivityService.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('No Internet Connection'),
            content:
                Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      final snackBar = SnackBar(
        content: Text('No internet connection'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return; // Return early to avoid the rest of the code
    }
// The rest of your logic (e.g., loading station data) can go here
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getUserDetails() async {
    try {
      var data = await GetMethod.getRequest(context,
          '${Urls().userUrl}/manageUser/getUserByUserId?userId=${widget.userId}');
      setState(() {
        firstNameEdited = data['userFirstName'];
        lastNameEdited = data['userLastName'];
        emailIdEdited = data['userEmail'];
        contactNoEdited = data['userContactNo'];
      });
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // var for updating the dark and light mode upon certain condition

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
        ),
        body: Column(children: [
// profile section
          Container(
            width: double.infinity,
            color: Color(0xFFEBF8EA),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                "Profile",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ),
          ),

// edit profile button
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => EditProfileScreen(
                                userId: widget.userId.toString(),
                                firstNameEdited:
                                    widget.firstNameEdited.toString(),
                                lastNameEdited:
                                    widget.lastNameEdited.toString(),
                                emailIdEdited: widget.emailIdEdited.toString(),
                                contactNoEdited:
                                    widget.contactNoEdited.toString(),
                              ))),
                    );
                  });
                },
                title: const Text(
                  "Edit Profile",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),
// change password
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen(
                              emailId: widget.emailIdEdited.toString())));
                },
                title: const Text(
                  "Change Password",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.lock_open,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),
// notifications section
          Container(
            width: double.infinity,
            color: Color(0xFFEBF8EA),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                "Notifications",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ),
          ),
// notificaton preference container
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  "Notifications Preferences",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.notification_important,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),

// languages section
          Container(
            width: double.infinity,
            color: Color(0xFFEBF8EA),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                "Regional",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ),
          ),
// choose languages container
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  "Languages",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.language,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),

// actions section
          Container(
            width: double.infinity,
            color: Color(0xFFEBF8EA),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
              child: Text(
                "Actions",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                ),
              ),
            ),
          ),

// Delete container
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  "Delete my Account",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),

// logout button
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  "Logout",
                  textAlign: TextAlign.start,
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                ),
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),

// dark mode button
//           Container(
//             decoration: const BoxDecoration(
//                 border: Border(bottom: BorderSide(width: 0.1))),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 5, right: 5),
//               child: ListTile(
//                   onTap: () {},
//                   title: const Text(
//                     "Dark Mode",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   leading: const Icon(
//                     Icons.dark_mode,
//                     color: Colors.green,
//                   ),
//                   trailing: Switch(
//                     value: isDarkModeEnabled,
//                     onChanged: (value) {
//                       setState(() {
//                         isDarkModeEnabled = value;
//                         isDarkModeEnabled
//                             ? themeChanger.setTheme(ThemeMode.dark)
//                             : themeChanger.setTheme(ThemeMode.light);
//                       });
//                     },
//                   )),
//             ),
//           ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PolicyScreen(title: "Privacy Polices")));
                },
                title: const Text(
                  "Privacy Polices",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.privacy_tip,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 0.1))),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PolicyScreen(title: "Terms Conditions")));
                },
                title: const Text(
                  "Terms Conditions",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                leading: const Icon(
                  Icons.security,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: MediaQuery.of(context).size.width * 0.07,
                ),
              ),
            ),
          ),
        ]));
  }
}
