import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/rounds/add_question_to_round.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';

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
  bool _revealAnswer = false;

  void _updateRevealAnswer() {
    setState(() {
      _revealAnswer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxHeight: 256),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Container(
                      child: Text(
                        widget.questionModel.question,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    GestureDetector(
                      onTap: () {
                        _updateRevealAnswer();
                      },
                      child: Container(
                        child: Text(
                          _revealAnswer ? widget.questionModel.answer : 'Show Answer',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    InfoColumn(
                      title: 'Points',
                      value: widget.questionModel.points.toString(),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    InfoColumn(
                      title: 'Category',
                      value: widget.questionModel.category,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoColumn(
                          title: 'Created',
                          value: DateFormat('dd-mm-yyyy').format(widget.questionModel.createdAt),
                        ),
                        InfoColumn(
                          title: 'Updated',
                          value: DateFormat('dd-mm-yyyy').format(widget.questionModel.lastUpdated),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16))
                  ],
                ),
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
