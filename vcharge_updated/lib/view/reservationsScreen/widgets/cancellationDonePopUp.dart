import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CancellationDonePopUp extends StatelessWidget{
  const CancellationDonePopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Wrap(
        children: [
          //container for the top icon
          SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              //this stack consist of a container with a color and a icon in center
              child: Stack(
                children: [
                  //container has half the height of its parent container, so that it should fit according to the design
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 137, 175, 76),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    // width: double.infinity / 2,
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  //this consist of the done Icon
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      elevation: 5,
                      child: CircleAvatar(
                        child: Icon(
                          Icons.done_rounded,
                          size: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    ),
                  ),

                  //Cross button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: FaIcon(FontAwesomeIcons.x, color: Colors.white,size: Get.width * 0.045,)),
                  ),
                ],
              )),

          Text(
            'Your Booking Has Been Successfully Cancelled.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),

          //Container for added successfully text
          Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: const Center(
                  child: Text(
                'Thank You For Using Our Service',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ))),

          

        ],
      ),
    );
  }

}