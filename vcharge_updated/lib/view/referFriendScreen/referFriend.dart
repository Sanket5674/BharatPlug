import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class ReferFriend extends StatefulWidget {
  const ReferFriend({super.key});

  @override
  State<ReferFriend> createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  // String variables for storing the instructions
  String firstInstruction = "Share your Referral link";
  String secondInstruction = "Your friend will recieve a referral link";
  String thirdInstruction =
      "Friend signs up and completes fast charging session";
  String fourthInstruction = "You'll receive reward";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Refer a Friend"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Invite and earn
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03),
              child: Text(
                "Invite & Earn",
                style: TextStyle(
                    fontSize: Get.height * 0.025, fontWeight: FontWeight.w500),
              ),
            ),

            // image container
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.08),
              height: MediaQuery.of(context).size.height * 0.32,
              child: SvgPicture.asset('assets/images/referFriend.svg'),
            ),

            // row for instructions

            // first instruction
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.09),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 15),
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: Get.height * 0.023,
                            child: FaIcon(
                              FontAwesomeIcons.one,
                              size: Get.height * 0.021,
                            )),
                      ),
                      Text(
                        firstInstruction,
                        style: TextStyle(
                            fontSize: Get.height * 0.019, color: Colors.black),
                      )
                    ],
                  )),
            ),

            // second instruction
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 15),
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: Get.height * 0.023,
                            child: FaIcon(
                              FontAwesomeIcons.two,
                              size: Get.height * 0.021,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          secondInstruction,
                          style: TextStyle(
                              fontSize: Get.height * 0.019,
                              color: Colors.black),
                        ),
                      )
                    ],
                  )),
            ),

            // third instruction
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 15),
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: Get.height * 0.023,
                            child: FaIcon(
                              FontAwesomeIcons.three,
                              size: Get.height * 0.021,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          thirdInstruction,
                          style: TextStyle(
                              fontSize: Get.height * 0.019,
                              color: Colors.black),
                        ),
                      )
                    ],
                  )),
            ),
            //fourth Instruction
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 15),
                        child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: Get.height * 0.023,
                            child: FaIcon(
                              FontAwesomeIcons.four,
                              size: Get.height * 0.021,
                            )),
                      ),
                      Expanded(
                        child: Text(
                          fourthInstruction,
                          style: TextStyle(
                              fontSize: Get.height * 0.019,
                              color: Colors.black),
                        ),
                      )
                    ],
                  )),
            ),

            // sharing button
            Container(
              margin: EdgeInsets.only(top: Get.height * 0.04),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () {
                    Share.share("https://virtuososofttech.com/");
                    // //print("Shared successfully");
                  },
                  child: SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.ios_share,
                          color: Colors.black,
                        ),
                        Text("Invite Your Friends Now",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                  )),
            ),
          ]),
    );
  }
}
