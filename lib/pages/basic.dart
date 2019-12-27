import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_service.dart';
import 'dart:async';

class BasicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);
    if (blue.currentState == BleAppState.connected) {
      Timer.periodic(Duration(seconds: 5), (timer) {
        blue.sendMessage();
      });
    }

    return Container(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Text("Basic Controls", style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          Card(
            child: Column(
              children: <Widget>[
                MotorSlider(motorIndex: 0),
                MotorSlider(motorIndex: 1),
                MotorSlider(motorIndex: 2),
                Row(
                  children: <Widget>[
                    LedPicker(ledIndex: 0),
                    LedPicker(ledIndex: 1),
                    LedPicker(ledIndex: 2),
                    LedPicker(ledIndex: 3),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            onPressed: () async {
              await blue.disconnect();
              print('Disconnected');
              Navigator.pushReplacementNamed(context, '/scan');
            },
            padding: EdgeInsets.all(15.0),
            child: Text('Disconnect',
                style: TextStyle(
                  fontSize: 25.0,
                )),
          ),
        ],
      )),
    );
  }
}

class MotorSlider extends StatelessWidget {
  MotorSlider({@required this.motorIndex});

  final int motorIndex;

  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 8.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('M${motorIndex + 1}'),
          Expanded(
            child: Slider(
              onChanged: (value) async {
                blue.update('MotorSpd', motorIndex, value);
              },
              value: blue.controlProperties['MotorSpd'][motorIndex],
              min: 0.0,
              max: 12.0,
              divisions: 12,
              label: blue.controlProperties['MotorSpd'][motorIndex].toString(),
            ),
          ),
          Switch(
            value: blue.controlProperties['MotorDir'][motorIndex] > 0.0
                ? true
                : false,
            onChanged: (value) {
              blue.update('MotorDir', motorIndex, value ? 1.0 : 0.0);
            },
          ),
        ],
      ),
    );
  }
}

class LedPicker extends StatelessWidget {
  LedPicker({@required this.ledIndex});

  final int ledIndex;

  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);
    return Container(
      height: 100.0,
      width: 100.0,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        onSelectedItemChanged: (selectedIndex) {
          blue.update('LEDColor', ledIndex, selectedIndex.toDouble());
        },
        itemExtent: 32.0,
        children: [
          Text('Off'),
          Text('Red'),
          Text('Orange'),
          Text('Yellow'),
          Text('Green'),
          Text('Cyan'),
          Text('Blue'),
          Text('Purple'),
        ],
      ),
    );
  }
}
