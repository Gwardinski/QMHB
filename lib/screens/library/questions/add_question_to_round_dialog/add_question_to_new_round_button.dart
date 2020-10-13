import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/rounds/round_create_dialog.dart';

class AddQuestionToNewRoundButton extends StatelessWidget {
  AddQuestionToNewRoundButton({
    this.initialQuestion,
  });

  final QuestionModel initialQuestion;

  openNewRoundForm(context) {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: initialQuestion,
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
                  "New Round",
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
