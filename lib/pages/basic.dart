import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_service.dart';
import 'package:superbot_app2/superbot_service.dart';

class BasicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);
    return Container(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Basic Controls", style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          Card(
              child: Column(
            children: <Widget>[
              MotorSlider(motorIndex: 0),
              MotorSlider(motorIndex: 1),
              MotorSlider(motorIndex: 2),
            ],
          )),
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
    final superbot = Provider.of<Superbot>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('M${motorIndex + 1}'),
          Expanded(
            child: Slider(
              onChanged: (value) async {
                superbot.update('MotorSpd', motorIndex, value);
              },
              value: superbot.properties['MotorSpd'][motorIndex],
              min: 0.0,
              max: 12.0,
              divisions: 12,
              label: superbot.properties['MotorSpd'][motorIndex].toString(),
            ),
          ),
        ],
      ),
    );
  }
}
