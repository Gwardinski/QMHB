import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';

class NoQuestionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: MaterialButton(
        child: Text(
          "Tap here to create your first Question. Or hit the explore tab to save a pre created question.",
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuestionEditorPage(
                type: QuestionEditorPageType.ADD,
              ),
            ),
          );
        },
      ),
    );
  }
}
