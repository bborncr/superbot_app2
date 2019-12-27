import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

enum BleAppState {
  searching,
  connected,
  invalid,
  failedToConnect,
}

class Bluetooth with ChangeNotifier {
  BleAppState _currentState = BleAppState.searching;
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final devices = Map<DeviceIdentifier, ScanResult>();
  final uartWriteCharacteristic = '6e400002-b5a3-f393-e0a9-e50e24dcca9e';
  BluetoothCharacteristic _characteristic;
  BluetoothDevice _currentDevice;

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _currentDevice = device;
      await device.connect(timeout: const Duration(seconds: 5));
      await _findCharacteristic(device);
      setMode(BleAppState.connected);
      // print('Characteristic: $_characteristic');
    } on TimeoutException {
      setMode(BleAppState.failedToConnect);
    }
  }

  Future disconnect() async {
    return await _currentDevice.disconnect();
  }

  Stream<Map<DeviceIdentifier, ScanResult>> scanForDevices() async* {
    yield null;
    var done = Completer<Map<DeviceIdentifier, ScanResult>>();
    if (await flutterBlue.isAvailable) {
      if (!await flutterBlue.isScanning.first) {
        devices.clear();
        flutterBlue.scan(
          timeout: const Duration(seconds: 5), // need longer to connect? 5?
          // UART service on the device...
          // withServices: [Guid('6E400001-B5A3-F393-­E0A9-­E50E24DCCA9E')],
          withServices: [],
        ).listen((ScanResult scanResult) {
          devices[scanResult.device.id] = scanResult;
        }, onDone: () => done.complete(devices));
      }
    } else {
      setMode(BleAppState.invalid);
    }
    yield await done.future;
  }

  sendMessage() async {
    for (int i = 0; i < 3; i++) {
      int spd = controlProperties['MotorSpd'][i].toInt();
      int dir = controlProperties['MotorDir'][i].toInt();
      controlProperties['MotorValue'][i] = (256 * dir - spd).abs();
    }
    List<int> header = [255, 254, 9, 1, 2];
    List<int> footer = [253, 252];
    List<int> packet = [];
    List<int> data = [
      controlProperties['MotorValue'][0],
      controlProperties['MotorValue'][1],
      controlProperties['MotorValue'][2],
      controlProperties['LEDColor'][0].toInt(),
      controlProperties['LEDColor'][1].toInt(),
      controlProperties['LEDColor'][2].toInt(),
      controlProperties['LEDColor'][3].toInt()
    ];
    packet.addAll(header);
    packet.addAll(data);
    packet.addAll(footer);
    print(packet);
    try {
      if (_characteristic == null) {
        return null;
      }
      await _characteristic?.write(packet);
    } on TimeoutException {
      // fail silently if we don't connect :-P
    } catch (e) {
      print(e);
    }
  }

  /// Find the UART Write characteristic to send messages between the app and the BLE device
  _findCharacteristic(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();

    // worst API ever.
    for (BluetoothService service in services) {
      _characteristic = service.characteristics.firstWhere(
          (BluetoothCharacteristic c) =>
              c.uuid.toString() == uartWriteCharacteristic,
          orElse: () => null);
      if (_characteristic != null) break;
    }
  }

  void setMode(BleAppState newState) {
    _currentState = newState;
    notifyListeners();
  }

  BleAppState get currentState => _currentState;

// Control properties and methods

  var controlProperties = {
    'MotorSpd': [0.0, 0.0, 0.0],
    'MotorDir': [0.0, 0.0, 0.0],
    'LEDColor': [0.0, 0.0, 0.0, 0.0],
    'MotorValue': [0, 0, 0],
  };

  void update(String key, int index, double value) {
    controlProperties[key][index] = value;
    sendMessage();
    notifyListeners();
  }

//    Motors OFF = 0, CW(1-12), CCW 256-(1-12)
//    LEDs 0=OFF, 1=RED, 2=ORANGE, 3=YELLOW, 4=GRN, 5=CYAN, 6=BLUE, 7=PURPLE
//    [255, 254, 9, 1, 2, Motor1, Motor2, Motor3, LED1, LED2, LED3, LED4, 253, 252]
//    [255, 254, 9, 1, 2, 0, 0, 0, 0, 0, 0, 0, 253, 252] // all off

}
