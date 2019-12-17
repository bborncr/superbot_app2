import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    countDown();
  }

  Future<Timer> countDown() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.pushReplacementNamed(context, '/scan');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SuperBot Controller'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Superbot Controller', style: TextStyle(fontSize: 28.0)),
//              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

