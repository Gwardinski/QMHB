import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';

class PlayScreen extends StatefulWidget {
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 8)),
            Center(
              child: Text("Play services are currently down for maintenance."),
            )
          ],
        ),
      ),
    );
  }
}
