import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class HighlightRow extends StatelessWidget {
  final List<QuizModel> quizzes;
  final List<RoundModel> rounds;

  const HighlightRow({
    this.quizzes,
    this.rounds,
  });

  @override
  Widget build(BuildContext context) {
    return quizzes != null
        ? QuizHighlightRow(
            quizzes: quizzes,
          )
        : RoundHighlightRow(
            rounds: rounds,
          );
  }
}

class QuizHighlightRow extends StatelessWidget {
  final List<QuizModel> quizzes;

  const QuizHighlightRow({
    @required this.quizzes,
  });

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

class RoundHighlightRow extends StatelessWidget {
  final List<RoundModel> rounds;
  const RoundHighlightRow({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: ListView.separated(
        itemCount: rounds?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (rounds.length - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          RoundModel roundModel = rounds[index];
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: roundModel.title,
              line2: "Questions",
              line2Value: roundModel.questionIds.length,
              line3: "Points",
              line3Value: roundModel.totalPoints,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundDetailsPage(
                      roundModel: roundModel,
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
