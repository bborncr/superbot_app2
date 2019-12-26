import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superbot_app2/bluetooth_service.dart';
import 'package:superbot_app2/pages/scan.dart';
import 'package:superbot_app2/pages/control.dart';
import 'package:superbot_app2/pages/splash.dart';
import 'package:superbot_app2/superbot_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Bluetooth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Superbot(),
        ),
      ],
      child: MaterialApp(
        title: 'SuperBot App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          '/scan': (context) => ScanPage(),
          '/control': (context) => ControlPage(),
        },
      ),
    );
  }
}
