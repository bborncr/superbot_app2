import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_state.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;

class ScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<Bluetooth>(context).scanForDevices(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Scaffold(body: AvailableDevices(snapshot.data));
          return Scaffold(
            appBar: AppBar(
              title: Text('Select Device'),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircularProgressIndicator(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Scanning for bluetooth devices'),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class AvailableDevices extends StatelessWidget {
  AvailableDevices(this.availableBLEDevices);
  final Map<blue.DeviceIdentifier, blue.ScanResult> availableBLEDevices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text('SCAN'),
          icon: Icon(Icons.search),
          onPressed: () {
            print('scanning');
            Provider.of<Bluetooth>(context).setMode(BleAppState.searching);
          },
        ),
        appBar: AppBar(
//        leading: Icon(Icons.menu),
          title: Text("Select Device"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                print('Exiting');
//              _ackAlert(context);
//              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              icon: Icon(Icons.menu),
              color: Colors.white,
            ),
          ],
        ),
        body: BluetoothListView(availableBLEDevices: availableBLEDevices));
  }
}

class BluetoothListView extends StatelessWidget {
  const BluetoothListView({
    Key key,
    @required this.availableBLEDevices,
  }) : super(key: key);

  final Map<blue.DeviceIdentifier, blue.ScanResult> availableBLEDevices;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: availableBLEDevices.values
            .where((result) => result.device.name.length > 0)
            .map<Widget>((result) => ListTile(
                  trailing: (result.device.name == 'Nordic_TUDAO')
                      ? Chip(
                          label: Text('Superbot Detected',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.redAccent,
                        )
                      : null,
                  leading: Icon(Icons.bluetooth),
                  title: Text(result.device.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold)),
                  subtitle: Text(result.device.id.toString()),
                  onTap: () {
                    connectToDevice(context, result.device);
                  },
                ))
            .toList());
  }
}

void connectToDevice(BuildContext context, device) async {
  await Provider.of<Bluetooth>(context).connectToDevice(device);
  print(Provider.of<Bluetooth>(context).currentState);
  if (Provider.of<Bluetooth>(context).currentState == BleAppState.connected) {
    Navigator.pushNamed(context, '/control');
  }
}
