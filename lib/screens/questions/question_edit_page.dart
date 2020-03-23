import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionEditPage extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionEditPage({this.questionModel});
  @override
  _QuestionEditPageState createState() => _QuestionEditPageState();
}

class _QuestionEditPageState extends State<QuestionEditPage> {
  bool isNew;

  @override
  Widget build(BuildContext context) {
    isNew = widget.questionModel == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? "Create Question" : "Edit Question"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
