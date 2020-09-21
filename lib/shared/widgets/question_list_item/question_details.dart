import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/rounds/add_question_to_round.dart';

class QuestionDetails extends StatefulWidget {
  const QuestionDetails({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  final QuestionModel questionModel;

  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetails> {
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
                      widget.questionModel.question,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.questionModel.answer,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.questionModel.category,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      "${widget.questionModel.points.toString()} points",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  Text(
                    DateTime.fromMicrosecondsSinceEpoch(
                      widget.questionModel.createdAt,
                    ).toString(),
                  ),
                  Text(
                    DateTime.fromMicrosecondsSinceEpoch(
                      widget.questionModel.lastUpdated,
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
                    _addQuestionToRound();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _addQuestionToRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddQuestionToRoundPage(
          questionModel: widget.questionModel,
        );
      },
    );
  }
}
