import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class QuizHighlightRow extends StatelessWidget {
  final List<QuizModel> quizzes;
  const QuizHighlightRow({
    Key key,
    @required this.quizzes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: ListView.separated(
        itemCount: quizzes?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (quizzes.length - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          QuizModel quizModel = quizzes[index];
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: quizModel.title,
              line2: "Rounds",
              line2Value: quizModel.roundIds.length,
              line3: "Points",
              line3Value: quizModel.totalPoints,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizDetailsPage(
                      quizModel: quizModel,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
