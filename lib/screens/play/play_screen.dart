import 'package:flutter/material.dart';

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
        child: Center(
          child: Text("Play Quiz"),
        ),
      ),
    );
  }
}
