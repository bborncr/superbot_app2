import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_service.dart';

class BasicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Sensor 1: ${blue.readProperties['sensor'][0].toString()}',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                  'Sensor 2: ${blue.readProperties['sensor'][1].toString()}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                  ],
                ),
                
                MotorSlider(motorIndex: 0),
                MotorSlider(motorIndex: 1),
                MotorSlider(motorIndex: 2),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    LedChooser(ledIndex: 0),
                    LedChooser(ledIndex: 1),
                    LedChooser(ledIndex: 2),
                    LedChooser(ledIndex: 3),
                    // LedPicker(ledIndex: 0),
                    // LedPicker(ledIndex: 1),
                    // LedPicker(ledIndex: 2),
                    // LedPicker(ledIndex: 3),
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
            padding: EdgeInsets.all(12.0),
            child: Text('Disconnect',
                style: TextStyle(
                  fontSize: 20.0,
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

  final List<Widget> ledColors = [
    Text('Off'),
    Text('Red'),
    Text('Orange'),
    Text('Yellow'),
    Text('Green'),
    Text('Cyan'),
    Text('Blue'),
    Text('Purple'),
  ];

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
        children: ledColors,
      ),
    );
  }
}

class LedChooser extends StatelessWidget {
  LedChooser({@required this.ledIndex});

  final int ledIndex;

  // final List<Widget> ledColors = [
  //   Text('Off'),
  //   Text('Red'),
  //   Text('Orange'),
  //   Text('Yellow'),
  //   Text('Green'),
  //   Text('Cyan'),
  //   Text('Blue'),
  //   Text('Purple'),
  // ];

  final List<Widget> ledColors = [
    Container(color: Colors.black, width: 50.0, height: 30.0),
    Container(color: Colors.red, width: 50.0, height: 30.0),
    Container(color: Colors.orange, width: 50.0, height: 30.0),
    Container(color: Colors.yellow, width: 50.0, height: 30.0),
    Container(color: Colors.green, width: 50.0, height: 30.0),
    Container(color: Colors.cyan, width: 50.0, height: 30.0),
    Container(color: Colors.blue, width: 50.0, height: 30.0),
    Container(color: Colors.purple, width: 50.0, height: 30.0),
  ];

  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<Bluetooth>(context);
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < ledColors.length; i++) {
      final DropdownMenuItem newItem = DropdownMenuItem(
        value: i,
        child: ledColors[i],
      );
      items.add(newItem);
    }
    return DropdownButton(
      value: blue.controlProperties['LEDColor'][ledIndex].toInt(),
      onChanged: (selectedIndex) {
        blue.update('LEDColor', ledIndex, selectedIndex.toDouble());
      },
      items: items,
    );
  }
}
