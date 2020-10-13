import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_create_dialog.dart';

class AddRoundToNewQuizButton extends StatelessWidget {
  AddRoundToNewQuizButton({
    this.initialRound,
  });

  final RoundModel initialRound;

  openNewRoundForm(context) {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizCreateDialog(
          initialRound: initialRound,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openNewRoundForm(context);
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.add_circle,
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "New Quiz",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
