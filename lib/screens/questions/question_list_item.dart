import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/questions/question_details_page.dart';
import 'package:qmhb/screens/questions/question_round_selector_page.dart';

class QuestionListItem extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionListItem({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  bool revealAnswer = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuestionDetailsPage(
                questionModel: widget.questionModel,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffFFA630),
                width: 0.25,
              ),
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      revealAnswer == true
                          ? widget.questionModel.answer
                          : widget.questionModel.question,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 18,
                        color: revealAnswer ? Color(0xffFFA630) : Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    child: Icon(
                      Icons.remove_red_eye,
                      color: revealAnswer ? Color(0xffFFA630) : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        revealAnswer = !revealAnswer;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Text("Points: "),
                              Text(
                                widget.questionModel.points.toString(),
                                style: TextStyle(
                                  color: Color(0xffFFA630),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Row(
                            children: <Widget>[
                              Text("Category: "),
                              Text(
                                widget.questionModel.category,
                                style: TextStyle(
                                  color: Color(0xffFFA630),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    child: Icon(
                      Icons.add,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuestionToRoundSelectorPage(
                            questionId: widget.questionModel.uid,
                            questionPoints: widget.questionModel.points,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
