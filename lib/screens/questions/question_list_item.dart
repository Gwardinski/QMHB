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
          height: 96,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        revealAnswer == true
                            ? widget.questionModel.answer
                            : widget.questionModel.question,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 18, color: revealAnswer ? Color(0xffFFA630) : Colors.white),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          revealAnswer ? Icons.label : Icons.label_outline,
                          color: Color(0xffFFA630),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          revealAnswer = !revealAnswer;
                        });
                      },
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 16),
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
                      child: Container(
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
                    ),
                    // GestureDetector(
                    //   child: Container(
                    //     height: 40,
                    //     padding: EdgeInsets.only(left: 10),
                    //     child: Icon(
                    //       Icons.add,
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (context) => QuestionToRoundSelectorPage(
                    //           questionId: widget.questionModel.uid,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
