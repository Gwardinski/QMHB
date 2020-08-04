import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/list_items/list_item.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ListItemGrid extends StatelessWidget {
  final List<QuizModel> quizzes;
  final List<RoundModel> rounds;

  const ListItemGrid({
    this.quizzes,
    this.rounds,
  });

  @override
  Widget build(BuildContext context) {
    return quizzes != null
        ? QuizListItemGrid(
            quizzes: quizzes,
          )
        : RoundListItemGrid(
            rounds: rounds,
          );
  }
}

class QuizListItemGrid extends StatelessWidget {
  QuizListItemGrid({
    Key key,
    @required this.quizzes,
  }) : super(key: key);

  final List<QuizModel> quizzes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: ResponsiveGridList(
          desiredItemWidth: 400,
          minSpacing: 16,
          children: quizzes.map((QuizModel quizModel) {
            return ListItem(
              quizModel: quizModel,
            );
          }).toList()),
    );
  }
}

class RoundListItemGrid extends StatelessWidget {
  RoundListItemGrid({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final List<RoundModel> rounds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: ResponsiveGridList(
          desiredItemWidth: 400,
          minSpacing: 16,
          children: rounds.map((RoundModel roundModel) {
            return ListItem(
              roundModel: roundModel,
            );
          }).toList()),
    );
  }
}
