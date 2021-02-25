import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';

class PlayPage extends StatefulWidget {
  final QuizModel quizModel;

  PlayPage({this.quizModel});

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Players"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
