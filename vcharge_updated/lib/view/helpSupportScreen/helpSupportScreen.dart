import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcharge/services/PostMethod.dart';
import 'package:vcharge/view/helpSupportScreen/ticketsHistory.dart';
import '../../services/urls.dart';

// ignore: must_be_immutable
class HelpSupportScreen extends StatefulWidget {
  String userId;

  HelpSupportScreen({super.key, required this.userId});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // var for officeLocation
  String officeLocationAddress =
      "Pride Icon, 108-109, Thite Vasti, Thite Nagar, Kharadi, Pune, Maharashtra, 411014";

// function for making phone call
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

// function for sending email
  Future<void> sendEmail({required String email, String subject = ""}) async {
    String mail = "mailto:$email?subject=$subject";
    if (await canLaunchUrl(Uri.parse(mail))) {
      await launchUrl(Uri.parse(mail));
    } else {
      throw Exception("Unable to open email app");
    }
  }

// function for opening whatsapp
  Future<void> openWhatsapp(
      {required BuildContext context,
      required String text,
      required String number}) async {
    var whatsapp = number;
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }

    // for android phones as well as for web also
    else {
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Whatsapp not installed")));
      }
    }
  }

// function for launchMaps
  void launchMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/place/Virtuoso+SoftTech/@$latitude,$longitude,17z/data=!4m6!3m5!1s0x3bc2c1f2f1569095:0xead616dbb3ceeabc!8m2!3d18.5434676!4d73.9362535!16s%2Fg%2F11sd0h5jyp';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

// function for opening facebook
  void openFacebookPage() async {
    const String facebookUrlScheme =
        'facebook://user?screen_name=VirtuosoSoftTech';
    const String facebookUrlWeb = 'https://www.facebook.com/VirtuosoSoftTech';

    try {
      if (await canLaunchUrl(Uri.parse(facebookUrlScheme))) {
        await launchUrl(Uri.parse(facebookUrlScheme));
      } else if (await canLaunchUrl(Uri.parse(facebookUrlWeb))) {
        await launchUrl(Uri.parse(facebookUrlWeb));
      } else {
        throw 'Could not launch $facebookUrlWeb';
      }
    } catch (e) {
      //Components().showSnackbar(Components().something_want_wrong, context);
      await launchUrl(Uri.parse(facebookUrlWeb));
    }
  }

// function for opening instagram
  Future<void> openInstagramProfile(String username) async {
    final instagramUrlScheme = 'intagram://user?screen_name=$username/';
    final instagramUrlWeb = 'https://www.instagram.com/$username/';

    if (await canLaunchUrl(Uri.parse(instagramUrlScheme))) {
      await launchUrl(Uri.parse(instagramUrlScheme));
    } else if (await canLaunchUrl(Uri.parse(instagramUrlWeb))) {
      await launchUrl(Uri.parse(instagramUrlWeb));
    } else {
      throw 'Could not launch $instagramUrlWeb';
    }
  }

// function for opening twitter
  Future<void> openTwitterPage() async {
    const twitterUrlScheme = 'twitter://user?screen_name=VirtuosoSoftech';
    const twitterUrlWeb = 'https://twitter.com/VirtuosoSoftech';

    if (await canLaunchUrl(Uri.parse(twitterUrlScheme))) {
      await launchUrl(Uri.parse(twitterUrlScheme));
    } else if (await canLaunchUrl(Uri.parse(twitterUrlWeb))) {
      await launchUrl(Uri.parse(twitterUrlWeb));
    } else {
      throw 'Could not launch $twitterUrlWeb';
    }
  }

// function for opening company's website
  void website() async {
    const websiteUrl = 'https://virtuososofttech.com/';
    if (await canLaunchUrl(Uri.parse(websiteUrl))) {
      await launchUrl(Uri.parse(websiteUrl));
    } else {
      throw 'Could not launch $websiteUrl';
    }
  }

// controllers having values when one wants to raise a doubt
  TextEditingController titleController = TextEditingController();
  dynamic selectedCategory;
  dynamic selectedSubCategory;
  TextEditingController descriptionController = TextEditingController();
  // var for storing the selected image
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers for title and description fields
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Function to reset the entered data
  void resetData() {
    setState(() {
      selectedCategory = null;
      selectedSubCategory = null;
      titleController.text = '';
      descriptionController.text = '';
    });
  }

// list for selecting category and subcategory
  List<String> categoryList = ['Technical', 'Financial'];
  List<String> subCategoryTechnical = ['Stations', 'Chargers', 'Connectors'];
  List<String> subCategoryFinancial = ['Booking', 'Transactions', 'Wallet'];

// bool variable indicating that by default subcategory dropdown will be enabled
  bool isSubCategoryEnabled = false;

  // function for gallery permissions
  Future<void> requestPermissions() async {
    // //print(statuses);
  }

  // variable for picking the image from the gallery or camera
  final ImagePicker picker = ImagePicker();

// function for fetching the image from the device
  Future getImage(ImageSource source) async {
    PermissionStatus storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      try {
        // temp var used to store the image once picked
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile == null) return;
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      } catch (error) {
        // //print("error: $error");
      }
    } else {
      // The user has not granted the necessary permissions, show an error message.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please grant the necessary permissions.')),
      );
    }
  }

  // url for raising the ticket
  String addTicketUrl = "${Urls().supportUrl}/manageSupport/addSupport";

  // post request
  Future<void> raiseTicket() async {
    try {
      dynamic screenShot;
      if (selectedImage != null) {
        screenShot = selectedImage?.path;
      } else {
        screenShot = null;
      }

      //print("the selected image is: $selectedImage");
      //print("the screenshot is: $screenShot");

      final response = await PostMethod.postRequest(
          addTicketUrl,
          jsonEncode({
            "supportCustomerId": widget.userId,
            "supportSubject": titleController.text,
            "supportDescription": descriptionController.text,
            "supportCategory": selectedCategory,
            "subSupportCategory": selectedSubCategory,
            "supportPriority": 'high',
            "supportImageLink": screenShot,
          }));

      if (response == 200) {
        Fluttertoast.showToast(
            msg: "Ticket raised successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Ticket wasn't rasied",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      // Components().showSnackbar(Components().something_want_wrong, context);
      //print("the error in support page is: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Help and Support"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // buttons
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30.0),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Wrap(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      topRight: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      // used to handle the onFocus() activities
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // container for title section
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: TextFormField(
                                              cursorColor: Colors.green,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                label: Text("Title"),
                                                border: OutlineInputBorder(),
                                                prefixIcon: Icon(Icons.title),
                                              ),
                                              controller: titleController,
                                            ),
                                          ),

                                          // categories and respective subcategories
                                          Container(
                                              width: Get.width * 0.83,
                                              child: Row(
                                                children: [
                                                  // section for category
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField(
                                                      value: selectedCategory,
                                                      items:
                                                          categoryList.map((e) {
                                                        return DropdownMenuItem(
                                                            value: e,
                                                            child: Text(e));
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedCategory =
                                                              value as String;
                                                          selectedSubCategory =
                                                              null;
                                                          isSubCategoryEnabled =
                                                              true;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Category',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),

                                                  // section for subcategory
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField(
                                                      value:
                                                          selectedSubCategory,
                                                      items: isSubCategoryEnabled &&
                                                              selectedCategory ==
                                                                  categoryList[
                                                                      1]
                                                          ? subCategoryFinancial
                                                              .map((e) {
                                                              return DropdownMenuItem(
                                                                  value: e,
                                                                  child:
                                                                      Text(e));
                                                            }).toList()
                                                          : isSubCategoryEnabled &&
                                                                  selectedCategory ==
                                                                      categoryList[
                                                                          0]
                                                              ? subCategoryTechnical
                                                                  .map((e) {
                                                                  return DropdownMenuItem(
                                                                      value: e,
                                                                      child: Text(
                                                                          e));
                                                                }).toList()
                                                              : null,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSubCategory =
                                                              value as String;
                                                        });
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Sub Category',
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),

                                          // container for Description section
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: TextFormField(
                                              minLines: 1,
                                              maxLines: 10,
                                              cursorColor: Colors.green,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.all(
                                                        Get.width * 0.03),
                                                    child: const FaIcon(
                                                        FontAwesomeIcons
                                                            .addressBook),
                                                  ),
                                                  label:
                                                      const Text("Description"),
                                                  border:
                                                      const OutlineInputBorder()),
                                              controller: descriptionController,
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                requestPermissions();
                                                getImage(ImageSource.gallery);
                                              },
                                              icon: const Icon(
                                                Icons.image,
                                                color: Colors.green,
                                              ),
                                              label: const Text(
                                                "Upload Screenshot",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),

                                          /*
                            */
                                          // button for submiting the doubt or ticket
                                          ElevatedButton(
                                              onPressed: () {
                                                raiseTicket();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Submit",
                                                  style: TextStyle(
                                                      color: Colors.black))),

                                          // added so that when keyboard pops up, sheet should not hide behind
                                          Padding(
                                              padding: MediaQuery.of(context)
                                                  .viewInsets)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Raise a ticket',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // button for ticket history
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the button color
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketHistoryScreen(
                                    userId: widget.userId)));
                      },
                      child: const Text(
                        "Ticket's history",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      )),
                ],
              ),
            ),

// image container
            Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.09),
              height: MediaQuery.of(context).size.height * 0.26,
              child: SvgPicture.asset('assets/images/helpSupport.svg'),
            ),

// calling button
            Container(
              width: Get.width * 0.8,
              margin: EdgeInsets.only(top: Get.height * 0.01),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _makePhoneCall('tel: 9699724732');
                    });
                  },
                  child: SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "call :",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "9699724732",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.height * 0.02,
                              // fontWeight: FontWeight.w400
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),

// email button
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              width: Get.width * 0.8,
              child: ElevatedButton(
                  onPressed: () {
                    sendEmail(email: "charge@bharatplug.com", subject: "");
                  },
                  child: SizedBox(
                    width: Get.width * 0.9,
                    height: Get.height * 0.056,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.email),
                        Text(
                          "email:",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Get.height * 0.022,
                              fontWeight: FontWeight.w500),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "charge@bharatplug.com",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: Get.height * 0.02),
                          ),
                        )
                      ],
                    ),
                  )),
            ),

// sharing button
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.01),
              width: Get.width * 0.8,
              child: ElevatedButton(
                  onPressed: () {
                    openWhatsapp(
                        context: context,
                        text: "Welcome to Vcharge support!",
                        number: "9699724732");
                  },
                  child: SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // whatsapp icon
                        const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                        ),

                        // whtsapp text
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Whatsapp",
                            style: TextStyle(
                                color: Colors.black, fontSize: Get.height * 0.02
                                // fontSize: 17
                                ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),

// icons for bottom bar
            Container(
              width: Get.width * 0.6,
              height: Get.height * 0.05,
              margin: EdgeInsets.only(
                  top: Get.height * 0.04, left: Get.width * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // facebook icon
                  Container(
                    width: Get.width * 0.07,
                    margin: EdgeInsets.only(right: Get.width * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          openFacebookPage();
                        },
                        child: Image.asset("assets/images/facebook.png")),
                  ),

                  // instagram icon
                  Container(
                    width: Get.width * 0.07,
                    margin: EdgeInsets.only(right: Get.width * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          openInstagramProfile('virtuososofttech');
                        },
                        child: Image.asset("assets/images/instagram.png")),
                  ),

                  // twitter icon
                  Container(
                    width: Get.width * 0.07,
                    margin: EdgeInsets.only(right: Get.width * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          openTwitterPage();
                        },
                        child: Image.asset("assets/images/twitter.png")),
                  ),

                  // chrome or website icon
                  Container(
                    width: Get.width * 0.07,
                    margin: EdgeInsets.only(right: Get.width * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          website();
                        },
                        child: Image.asset("assets/images/chrome.png")),
                  ),
                ],
              ),
            ),

            // address section
            Expanded(
              child: Container(
                margin: EdgeInsets.all(Get.height * 0.05),
                width: Get.width * 0.7,
                child: const Text(
                  "Pride Icon, 108-109, Thite Vasti, Thite Nagar, Kharadi, Pune, Maharashtra 411014",
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]),
    );
  }
}
