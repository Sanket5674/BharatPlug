import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarkerHints extends StatefulWidget {
  const MarkerHints({super.key});

  @override
  State<MarkerHints> createState() => _MarkerHintsState();
}

class _MarkerHintsState extends State<MarkerHints> {
  //Vairiable to store the tapPosition Details
  // Offset tapPosition = Offset.zero;

  // //this function will get the tapped position and store the Offset position into our tapPosition global variable
  // void getTapPosition(TapDownDetails tapposition) {
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   setState(() {
  //     tapPosition = renderBox.globalToLocal(tapposition.localPosition);
  //   });
  //   //print(tapPosition);
  // }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "markerHintButton",
      value: 'markerHintButton',
      child: GestureDetector(
        key: const Key('markersHintButton'),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Adjust the radius as needed
                  ),
                  contentPadding: const EdgeInsets.all(
                      10.0), // Adjust the padding as needed
                  content: const Wrap(
                    children: [
                      //Row For Available
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 8,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: 1,
                        height: 5,
                      ),

                      //Row For Busy
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 8,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Busy',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: 1,
                        height: 5,
                      ),

                      //Row For Not Available
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 8,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Not Available',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          margin: const EdgeInsets.only(right: 13, bottom: 10),
          child: const CircleAvatar(
            backgroundColor: Colors.green,
            child: FaIcon(
              FontAwesomeIcons.question,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
