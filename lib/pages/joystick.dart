import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:superbot_app2/bluetooth_service.dart';

class JoystickPage extends StatelessWidget {
  static const double kDegreesToRadians = 0.0174533;

  @override
  Widget build(BuildContext context) {
    // final blue = Provider.of<Bluetooth>(context);
    double x;
    double y;
    return Container(
      child: Center(
        child: JoystickView(
          interval: Duration(milliseconds: 100),
          onDirectionChanged: (double direction, double value) {
            if (value > 0.05) {
              x = sin(direction * kDegreesToRadians) * value * 12;
              y = cos(direction * kDegreesToRadians) * value * 12;
            } else {
              x = 0.0;
              y = 0.0;
            }
            print('x: $x, y: $y');
            // print('Direction: $direction, Value: $value');
            // blue.update('MotorSpd', 0, y.abs());
            // blue.update('MotorDir', 0, x > 0.0 ? 1.0 : 0.0);
            // blue.update('MotorSpd', 1, x.abs());
            // blue.update('MotorDir', 1, x > 0.0 ? 0.0 : 1.0);
          },
        ),
      ),
    );
  }
}
