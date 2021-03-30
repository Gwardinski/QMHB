import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/pages/library/questions/editor/question_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';

class CreateFirstQuestionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: MaterialButton(
        child: Text(
          "Your library of Questions lives here.\n\nTap to create your first Question.\n\nOr you can head to the Explore tab to save a pre-created Question.",
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Provider.of<NavigationService>(context, listen: false).push(
            QuestionEditorPage(),
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
