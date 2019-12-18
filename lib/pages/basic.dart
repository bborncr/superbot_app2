import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_state.dart';

class BasicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Basic Controls", style: TextStyle(fontSize: 24.0)),
          SizedBox(height: 20.0),
          RaisedButton(
            onPressed: () async {
              await Provider.of<Bluetooth>(context).disconnect();
              print('Disconnected');
              Navigator.pushReplacementNamed(context, '/scan');
            },
            padding: EdgeInsets.all(15.0),
            child: Text('Disconnect',
                style: TextStyle(
                  fontSize: 30.0,
                )),
          ),
        ],
      )),
    );
  }
}
