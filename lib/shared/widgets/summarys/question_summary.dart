import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionSummary extends StatelessWidget {
  final Function(QuestionModel) onSummaryTap;
  final Function(QuestionModel) onAddQuestion;
  final QuestionModel questionModel;

  QuestionSummary({
    Key key,
    @required this.onSummaryTap,
    @required this.onAddQuestion,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool revealAnswer = false;
    return GestureDetector(
      onTap: () {
        onSummaryTap(questionModel);
      },
      child: Container(
        height: 80,
        color: Color(0xff6D6D6D),
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      revealAnswer == true ? questionModel.answer : questionModel.question,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.remove_red_eye,
                        color: Color(0xffFFA630),
                      ),
                    ),
                    onTapDown: (d) {
                      revealAnswer = true;
                    },
                    onTapUp: (d) {
                      revealAnswer = false;
                    },
                  )
                ],
              ),
            ),
            Container(
              height: 40,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Text("Catagory: "),
                          Text(
                            questionModel.category,
                            style: TextStyle(
                              color: Color(0xffFFA630),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 8),
                    child: Row(
                      children: <Widget>[
                        Text("Points: "),
                        Text(questionModel.points.toString()),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.add),
                    ),
                    onTap: () {
                      onAddQuestion(questionModel);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
