import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/quizzes/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

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
        color: isEven ? Color(0xff3b3b3b) : Color(0xff545454),
        child: Row(
          children: [
            SummaryTile(
              line1: "",
              line2: "Rounds",
              line2Value: quizModel.roundIds.length,
              line3: "Total Points",
              line3Value: quizModel.totalPoints,
              onTap: () {},
            ),
            Padding(padding: EdgeInsets.only(right: 8)),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      quizModel.title,
                      maxLines: 2,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      quizModel.description,
                      maxLines: 2,
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
