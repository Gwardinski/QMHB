import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/widgets/quiz_editor.dart';

class QuizEditorPage extends StatefulWidget {
  final QuizEditorType type;
  final QuizModel quizModel;
  final String initialRoundId;

  QuizEditorPage({
    @required this.type,
    this.quizModel,
    this.initialRoundId,
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
          widget.type == QuizEditorType.ADD ? "Create Quiz" : "Edit Quiz",
        ),
      ),
      body: QuizEditor(
        quizModel: widget.quizModel,
        type: widget.type,
        initialRoundId: widget.initialRoundId,
      ),
    );
  }
}
