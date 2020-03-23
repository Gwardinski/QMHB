import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/quizzes/quiz_details_page.dart';

class QuizListItem extends StatelessWidget {
  const QuizListItem({
    Key key,
    @required this.quizModel,
    @required this.isEven,
  }) : super(key: key);

  final QuizModel quizModel;
  final bool isEven;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizDetailsPage(
              quizModel: quizModel,
            ),
          ),
        );
      },
      child: Container(
        height: 120,
        padding: EdgeInsets.all(8),
        color: isEven ? Color(0xff6D6D6D) : Color(0xff656565),
        child: Row(
          children: [
            Container(
              height: 104,
              width: 104,
              color: Colors.blue,
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        quizModel.title,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          quizModel.roundIds.length.toString(),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          " Rounds",
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          quizModel.questionIds.length.toString(),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          " Questions",
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  quizModel.description ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
