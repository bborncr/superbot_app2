import 'package:flutter/foundation.dart';

class Superbot with ChangeNotifier {
  var properties = {
    'MotorSpd': [0.0, 0.0, 0.0],
    'MotorDir': [0.0, 0.0, 0.0],
    'LEDColor': [0.0, 0.0, 0.0, 0.0],
  };

  void update(String key, int index, double value) {
    properties[key][index] = value;
    notifyListeners();
  }

  // blue.sendMessage([
                //   255,
                //   254,
                //   9,
                //   1,
                //   2,
                //   superbot.properties['MotorSpd'][0].toInt(),
                //   superbot.properties['MotorSpd'][1].toInt(),
                //   superbot.properties['MotorSpd'][2].toInt(),
                //   0,
                //   0,
                //   0,
                //   0,
                //   253,
                //   252
                // ]);

//   writeData(List<int> data) {
//     // if (targetCharacteristic == null) return;
// //    Motors OFF = 0, CW(1-12), CCW 256-(1-12)
// //    LEDs 0=OFF, 1=RED, 2=ORANGE, 3=YELLOW, 4=GRN, 5=CYAN, 6=BLUE, 7=PURPLE
// //    [255, 254, 9, 1, 2, Motor1, Motor2, Motor3, LED1, LED2, LED3, LED4, 253, 252]
// //    [255, 254, 9, 1, 2, 0, 0, 0, 0, 0, 0, 0, 253, 252] // all off
//     List<int> header = [255, 254, 9, 1, 2];
//     List<int> footer = [253, 252];
//     List<int> packet = [];
//     packet.addAll(header);
//     packet.addAll(data);
//     packet.addAll(footer);
//     print(packet);
//     // targetCharacteristic.write(packet);
//   }
}
