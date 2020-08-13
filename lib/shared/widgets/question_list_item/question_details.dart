import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionDetails extends StatelessWidget {
  const QuestionDetails({
    Key key,
    @required this.questionModel,
    @required this.addQuestionToRound,
    @required this.deleteQuestion,
    @required this.editQuestion,
  }) : super(key: key);

  final QuestionModel questionModel;
  final addQuestionToRound;
  final deleteQuestion;
  final editQuestion;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(16),
      title: Text(questionModel.question),
      content: Container(
        constraints: BoxConstraints(maxHeight: 256),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(questionModel.answer),
                  Text(questionModel.category),
                  Text("${questionModel.points.toString()} points"),
                  Text(questionModel.createAt.toString()),
                  Text(questionModel.lastUpdated.toString()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: const Text('Add To Round'),
                  onPressed: () {
                    Navigator.pop(context);
                    addQuestionToRound();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
