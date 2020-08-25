import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor.dart';

class QuizEditorPage extends StatefulWidget {
  final QuizModel quizModel;

  QuizEditorPage({
    @required this.quizModel,
  });

  @override
  _QuizEditorPageState createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Quiz",
        ),
      ),
      body: QuizEditor(
        quizModel: widget.quizModel,
      ),
    );
  }
}
