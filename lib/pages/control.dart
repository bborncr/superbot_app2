import 'package:flutter/material.dart';
import 'package:superbot_app2/pages/basic.dart';
import 'package:superbot_app2/pages/joystick.dart';

class ControlPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nordic_TUDAO"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.view_quilt)),
              Tab(icon: Icon(Icons.videogame_asset)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            BasicPage(),
            JoystickPage(),
          ],
        ),
      ),
    );
  }
}
