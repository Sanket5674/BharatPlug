import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ConfirmationSuccessPopUp extends StatefulWidget {
  const ConfirmationSuccessPopUp({super.key});

  @override
  State<ConfirmationSuccessPopUp> createState() => _ConfirmationSuccessPopUpState();
}

class _ConfirmationSuccessPopUpState extends State<ConfirmationSuccessPopUp> {


  String instructionOne = "";
  String instructionTwo = "";

  @override
  Widget build(BuildContext context) {

    // return Container();

    return Wrap(
      children: [
        //Following statck include cross button
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 130, 199, 85),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                
                //Cross Button
                Positioned(
                    top: 5,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: FaIcon(
                            FontAwesomeIcons.x,
                            size: 18,
                            color: Color.fromARGB(255, 252, 252, 252),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),

        //Folowing id the container for all the other assets
        SizedBox(
          height: 500,
          child: Column(
            children: [
              
              // title
              const Text("Check your mail", style: TextStyle(
                fontWeight: FontWeight.bold
              ),),

              // instruction 1
              Text(instructionOne),

              // email logo
              Icon(
                Icons.email,
                size: Get.height* 0.02,
              ),            


              // Button 1 - open app
              ElevatedButton(onPressed: (){}, 
              child: const Text("Open app"),
              ),

              // Button 2 - skip
               

              // instruction 2
              Text(instructionTwo),
            ],
          ),
        ),

        
      ],
    );
  }
}