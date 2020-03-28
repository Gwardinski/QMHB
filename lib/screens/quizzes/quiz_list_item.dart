import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/quizzes/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class QuizListItem extends StatelessWidget {
  const QuizListItem({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(16),
      child: GestureDetector(
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
          color: Colors.transparent,
          height: 120,
          child: Row(
            children: [
              IgnorePointer(
                child: SummaryTile(
                  line1: "",
                  line2: "Rounds",
                  line2Value: quizModel.roundIds.length,
                  line3: "Total Points",
                  line3Value: quizModel.totalPoints,
                  onTap: () {},
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 8)),
              Expanded(
                child: Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
