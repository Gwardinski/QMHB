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
      content: Container(
        constraints: BoxConstraints(maxHeight: 256),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      questionModel.question,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      questionModel.answer,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      questionModel.category,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "${questionModel.points.toString()} points",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Text(
                    DateTime.fromMicrosecondsSinceEpoch(
                      questionModel.createdAt,
                    ).toString(),
                  ),
                  Text(
                    DateTime.fromMicrosecondsSinceEpoch(
                      questionModel.lastUpdated,
                    ).toString(),
                  ),
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
