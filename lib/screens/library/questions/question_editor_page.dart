import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/questions/question_editor.dart';

class QuestionEditorPage extends StatefulWidget {
  final QuestionEditorType type;
  final QuestionModel questionModel;

  QuestionEditorPage({
    @required this.type,
    this.questionModel,
  });

  @override
  _QuestionEditorPageState createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<QuestionEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == QuestionEditorType.ADD ? "Create Question" : "Edit Question",
        ),
      ),
      body: QuestionEditor(
        questionModel: widget.questionModel,
        type: widget.type,
      ),
    );
  }
}
