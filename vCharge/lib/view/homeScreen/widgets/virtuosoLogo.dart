import 'package:flutter/material.dart';

class VirtuosoLogo extends StatelessWidget {
  const VirtuosoLogo({super.key});

// this returns a widget which has logo
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "virtuosoLogo",
      value: "virtuosoLogo",
      child: Container(
        margin: const EdgeInsets.only(left: 13, bottom: 10),
        width: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
