import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';

class JoystickPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: JoystickView()),
    );
  }
}