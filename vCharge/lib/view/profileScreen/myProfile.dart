// ignore_for_file: use_build_context_synchronously

/*

----------------- SAMPLE REDIS CONNECTION CODE ------------------


// Client variable for redis connection
dynamic client;

// Command variable for redis connection
dynamic cmd;



Future<void> getUserData() async {
  client = RedisConnection();
  final response = await GetMethod.getRequest(specificUserIdUrl);

  profilePhoto = response['userProfilePhoto'];
  firstName = response['userFirstName'];
  lastName = response['userLastName'];
  contactNo = response['userContactNo'];
  emailId = response['userEmail'];


    cmd = await client.connect('192.168.0.136', 6379);
    await cmd.send_object(['SET','profilePhoto', profilePhoto]);
    await cmd.send_object(['SET','firstName', firstName]);
    await cmd.send_object(['SET','lastName', lastName]);
    client.close();
  setState(() {
    
  });
}







*/

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vcharge/services/GetMethod.dart';
import 'package:vcharge/view/homeScreen/widgets/virtuosoLogo.dart';
import 'package:vcharge/view/settingScreen/settingPage.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:redis/redis.dart' as redis;
import 'package:dio/dio.dart' as dio;
import '../../services/urls.dart';
import '../connectivity_service.dart';

// ignore: must_be_immutable
class MyProfilePage extends StatefulWidget {
  String? userId;

  MyProfilePage({super.key, required this.userId});
  //: super(key: GlobalKey)

  @override
  State<StatefulWidget> createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  final ConnectivityService _connectivityService = ConnectivityService();

  final GlobalKey<MyProfilePageState> globalKey = GlobalKey();

  final dio.Dio dioClient = dio.Dio();

  Future<String> uploadImageAndGetUrl(String imagePath) async {
    try {
      String userId;
      const storage = FlutterSecureStorage();
      userId = (await storage.read(key: 'userId'))!;
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(imagePath),
        "upload_preset": "your_cloudinary_upload_preset",
      });

      final response = await dioClient.post(
        "${Urls().userUrl}/manageUser/getUserByUserId?userId=$userId",
        data: formData,
      );

      final imageUrl = response.data['secure_url'];
      //print(imageUrl);
      return imageUrl;
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      //print(e);
      return ' ';
    }
  }

// variables for storing the REST API

  // String specificUserIdUrl = '';

// initstate function calling the getuserData method
  @override
  void initState() {
    super.initState();
    setState(() {});
    // specificUserIdUrl = "${Urls().baseUrl}8097/manageUser/user?userId=${widget.userId}";
    getUserData();
    _checkConnectivity();
  }

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
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      const snackBar = SnackBar(
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

// variables for storing the only displaying user details
  String firstName = '';
  String lastName = '';
  String contactNo = '';
  String emailId = '';
  var profilePhoto;

// Client variable for redis connection
  dynamic client;

// Command variable for redis connection
  dynamic cmd;

// function for setting up the redis connection and fetching the user data and setting up in the redis
  Future<void> getUserData() async {
    // client = redis.RedisConnection();
    try {
      String userId;
      const storage = FlutterSecureStorage();
      userId = (await storage.read(key: 'userId'))!;
      //print("userId : ${userId}");
      var response = await GetMethod.getRequest(context,
          "${Urls().userUrl}/manageUser/getUserByUserId?userId=${userId}");
      //print("userId : ${userId}");
      //print(response);

      //print("this is userProfilePhoto : ${response['userProfilePhoto']}");
      setState(() {
        response['userProfilePhoto'] == null
            ? profilePhoto = null
            : profilePhoto = base64Decode(response['userProfilePhoto']);
        firstName = response['userFirstName'];
        lastName = response['userLastName'];
        contactNo = response['userContactNo'];
        emailId = response['userEmail'];
      });
      cmd = await client.connect('192.168.0.241', 6379);

      await cmd.send_object(['SET', 'profilePhoto', profilePhoto]);
      await cmd.send_object(['SET', 'firstName', firstName]);
      await cmd.send_object(['SET', 'lastName', lastName]);
      await cmd.send_object(['SET', 'emailId', emailId]);
      await cmd.send_object(['SET', 'contactNo', contactNo]);
      client.close();
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print("the error at the redis connection in profile widget is: $e");
    }

    if (mounted) {
      setState(() {});
    }
  }

  String? base64string;

  Future convertJPGtoBase64(File image) async {
    Uint8List imagebytes = await image.readAsBytes();
    base64string = base64.encode(imagebytes);
    //print(base64string);
    updateImage(base64string.toString());
  }

  Future updateImage(String Base64Image) async {
    final requestBody = {
      'userProfilePhoto': Base64Image,
    };
    final requestBodyJson = json.encode(requestBody);
    try {
      String userId;
      const storage = FlutterSecureStorage();
      userId = (await storage.read(key: 'userId'))!;
      //print("userId IS: $userId");
      final response = await http.put(
        Uri.parse(
            "${Urls().userUrl}/manageUser/updateUserByUserId?userId=${userId}"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBodyJson,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        showSnackbar("${data['status']}");
        setState(() {
          getUserData();
        });
      } else {
        showSnackbar("Error: ${response.statusCode}");
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      showSnackbar(e.toString());
      //print("Error : $e");
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// variable for picking the image from the gallery or camera
  final ImagePicker picker = ImagePicker();

// var for storing the selected image
  File? selectedImage;

// function for gallery and camera permissions
  Future<void> requestPermissions() async {
    //print(status[Permission.camera].toString());
  }

  dynamic selectedImageUrl = '';

  // @override
  // void didUpdateWidget(MyProfilePage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   setState(() {
  //     getUserData();
  //   });
  // }

// function for fetching the image from the device
  Future getImage(ImageSource source) async {
    PermissionStatus cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      try {
        final ImagePicker imgPicker = ImagePicker();
        final photo = await imgPicker.pickImage(source: source);
        if (photo == null) return;
        final tempImage = File(photo.path);
        // selectedImageUrl = await uploadImageAndGetUrl(tempImage.path);
        setState(() {
          selectedImage = tempImage;
          //print("type of selectedImage: ${selectedImage}");
          profilePhoto = null;
          // //print("seelected image is: $selectedImage");
          convertJPGtoBase64(tempImage);
          // //print("The imageUrl is: $selectedImageUrl");
        });

        Get.back();
      } catch (error) {
        // debug//print(error.toString());
      }
    } else {
      // The user has not granted the necessary permissions, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please grant the necessary permissions.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

// function which returns the bottomsheet image
  Widget bottomSheet() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50.0),
        topRight: Radius.circular(50.0),
      ),
      child: Container(
        color: Colors.white,
        height: Get.height * 0.15,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Pick Image From",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      requestPermissions();
                      getImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      requestPermissions();
                      getImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

// function for displaying the semicircle at the top
  Widget greenIntroWidgetWithoutLogos(
      {String title = "My Profile", String? subtitle}) {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 198, 235, 199),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      height: Get.height * 0.17,
    );
  }

// function for displaying the sessions, referrals etc widget
  Widget textContainer(
      String title, IconData iconData, dynamic name, Function validator,
      {Function? onTap, bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // displaying text
        Text(
          title,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),

        // displaying name
        Container(
          width: Get.width,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
            child: Text(name),
          ),
        )
      ],
    );
  }

// function for nav bar icons -> back button and settings button
  Widget rowContainingNavBarIcons() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // back button
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.green,
                )),
          ),

          // settings button
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
                onPressed: () async {
                  String userId;
                  const storage = FlutterSecureStorage();
                  userId = (await storage.read(key: 'userId'))!;
                  var editProfile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => SettingPage(
                                userId: userId,
                                firstNameEdited: firstName,
                                lastNameEdited: lastName,
                                contactNoEdited: contactNo,
                                emailIdEdited: emailId,
                              ))));
                  if (editProfile == true) {
                    await getUserData();
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.green,
                )),
          ),
        ],
      ),
    );
  }

// function for the profile avtar
  Widget profileAvtarWidget() {
    final profileImg = profilePhoto == null
        ? const NetworkImage(
            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
        : Image.memory(profilePhoto).image;
    final decorationImg = DecorationImage(image: profileImg, fit: BoxFit.cover);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          // funtions for handling the edit profile photo widget
          onTap: () {
            showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));
          },

          child: profilePhoto == null
              ? selectedImage != null
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(bottom: 20),
                      // child: Image.file(selectedImage!),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          image: DecorationImage(
                              image: FileImage(selectedImage!),
                              fit: BoxFit.cover),
                          shape: BoxShape.rectangle,
                          color: const Color(0xffD6D6D6)),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.2,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(
                                5.0,
                                5.0,
                              ),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          shape: BoxShape.rectangle,
                          color: const Color(0xffD6D6D6)),
                      child: const Center(
                        child: Icon(
                          Icons.upload_file,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    )
              : Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.2,
                  margin: const EdgeInsets.only(bottom: 20),
                  // child: Image.network(profilePhoto),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                      image: decorationImg,
                      shape: BoxShape.rectangle,
                      color: const Color(0xffD6D6D6)),
                ),
        ),
      ),
    );
  }

// function for overlaying the edit icon over the profile avtar
  Widget editIconOverProfileAvtar() {
    return Positioned(
      bottom: 10,
      right: MediaQuery.of(context).size.width * 0.25,
      child: GestureDetector(
        // functions for handling the edit profile photo widget
        onTap: () {
          showModalBottomSheet(
              context: context, builder: ((builder) => bottomSheet()));
        },
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Icon(
                      Icons.edit,
                      size: MediaQuery.of(context).size.height * 0.028,
                      color: Colors.white,
                    ))),
          ),
        ),
      ),
    );
  }

// function for displaying user details
  Widget displayUserDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Form(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            // container for name
            textContainer('Name', Icons.person_outlined,
                " $firstName $lastName", (String? input) {}),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            // container for contact no
            textContainer('Contact No', Icons.home_outlined, contactNo,
                (String? input) {}),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            // container for email id
            textContainer(
                'Email id', Icons.card_travel, emailId, (String? input) {}),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

// function for savings portal
  Widget userSavingsPortal() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            children: [
              const Text(
                "Savings",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                    top: MediaQuery.of(context).size.height * 0.0047),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.currency_rupee_sharp),
                    ),
                    Text(
                      "200",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// function for sessions portal
  Widget userSessionsPortal() {
    return Expanded(
      child: Container(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            children: [
              const Text(
                "Sessions",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03,
                    top: MediaQuery.of(context).size.height * 0.0047),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.event),
                    ),
                    Text(
                      "02",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// function for referrals portal
  Widget userReferralsPortal() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          child: Column(
            children: [
              const Text(
                "Referrals",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02),
                child: const Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(Icons.person_2),
                    ),
                    Text(
                      "02",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Get.height * 0.3,

                  // main elements starts:
                  child: Stack(
                    children: [
                      // semicircle container
                      greenIntroWidgetWithoutLogos(),

                      // icons container
                      rowContainingNavBarIcons(),
                      Stack(
                        children: [
                          // profile avtar widget
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: profileAvtarWidget(),
                          ),

                          // edit button over the profie avtar
                          editIconOverProfileAvtar(),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),

                // display user details
                displayUserDetails(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),

                // container for sessions, referrals, savings
                IntrinsicHeight(
                  child: Row(
                    children: [
                      // savings portal
                      userSavingsPortal(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: const VerticalDivider()),

                      // sessions portal
                      userSessionsPortal(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: const VerticalDivider()),
                      userReferralsPortal(),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),

                // logo section
                Center(
                  child: Container(
                    child: const VirtuosoLogo(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
