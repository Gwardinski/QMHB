import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/widgets/round_editor.dart';

class RoundEditorPage extends StatefulWidget {
  final RoundModel roundModel;

  RoundEditorPage({
    this.roundModel,
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
          "Edit Round",
        ),
      ),
      body: RoundEditor(
        roundModel: widget.roundModel,
      ),
    );
  }
}
