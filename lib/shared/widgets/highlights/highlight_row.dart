import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/services/navigation_service.dart';
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
      child: ListView.separated(
        itemCount: quizzes?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: getIt<AppSize>().rSpacingMd)
              : index == (quizzes.length - 1)
                  ? EdgeInsets.only(right: getIt<AppSize>().rSpacingMd)
                  : EdgeInsets.all(0);
          QuizModel quiz = quizzes[index];
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: quiz.title,
              line2: "Rounds",
              line2Value: quiz.rounds.length.toString(),
              line3: "Points",
              line3Value: quiz.totalPoints.toString(),
              imageUrl: quiz.imageUrl,
              onTap: () {
                Provider.of<NavigationService>(context, listen: false).push(
                  QuizDetailsPage(
                    initialValue: quiz,
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
      child: ListView.separated(
        itemCount: rounds?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: getIt<AppSize>().rSpacingMd)
              : index == (rounds.length - 1)
                  ? EdgeInsets.only(right: getIt<AppSize>().rSpacingMd)
                  : EdgeInsets.all(0);
          RoundModel round = rounds[index];
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: round.title,
              line2: "Questions",
              line2Value: round.questions.length.toString(),
              line3: "Points",
              line3Value: round.totalPoints.toString(),
              imageUrl: round.imageUrl,
              onTap: () {
                Provider.of<NavigationService>(context, listen: false).push(
                  RoundDetailsPage(
                    initialValue: round,
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
