import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/widgets/round_editor.dart';

class RoundEditorPage extends StatefulWidget {
  final RoundEditorType type;
  final RoundModel roundModel;
  final String initialQuestionId;

  RoundEditorPage({
    @required this.type,
    this.roundModel,
    this.initialQuestionId,
  });

  @override
  _RoundEditorPageState createState() => _RoundEditorPageState();
}

class _RoundEditorPageState extends State<RoundEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == RoundEditorType.ADD ? "Create Round" : "Edit Round",
        ),
      ),
      body: RoundEditor(
        roundModel: widget.roundModel,
        type: widget.type,
        initialQuestionId: widget.initialQuestionId,
      ),
    );
  }
}
