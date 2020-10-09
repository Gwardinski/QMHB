import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';

class CreateFirstQuestionButton extends StatelessWidget {
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
                type: QuestionEditorType.ADD,
              ),
            ),
          );
        },
      ),
    );
  }
}

enum NoSavedItemsType {
  QUESTION,
  ROUND,
  QUIZ,
}

class NoSavedItems extends StatelessWidget {
  final NoSavedItemsType type;

  NoSavedItems({@required this.type});

  @override
  Widget build(BuildContext context) {
    final name = type == NoSavedItemsType.QUESTION
        ? "Questions"
        : type == NoSavedItemsType.ROUND
            ? "Rounds"
            : "Quizzes";
    return Container(
      height: 128,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          "You haven't saved any $name yet. \n Head to the Explore tab to start searching",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
