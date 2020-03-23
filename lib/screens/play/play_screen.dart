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
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ButtonPrimary(
              onPressed: () {},
              child: Text("Join Quiz"),
            ),
            ButtonPrimary(
              onPressed: () {},
              child: Text("Host Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
