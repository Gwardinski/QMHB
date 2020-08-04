import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/list_items/list_item.dart';

class ListItemColumn extends StatelessWidget {
  final List<QuizModel> quizzes;
  final List<RoundModel> rounds;

  const ListItemColumn({
    this.quizzes,
    this.rounds,
  });

  @override
  Widget build(BuildContext context) {
    return quizzes != null
        ? QuizListItemColumn(
            quizzes: quizzes,
          )
        : RoundListItemColumn(
            rounds: rounds,
          );
  }
}

class QuizListItemColumn extends StatelessWidget {
  QuizListItemColumn({
    Key key,
    @required this.quizzes,
  }) : super(key: key);

  final quizzes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      itemCount: quizzes.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        QuizModel quizModel = quizzes[index];
        return ListItem(
          quizModel: quizModel,
        );
      },
    );
  }
}

class RoundListItemColumn extends StatelessWidget {
  RoundListItemColumn({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final rounds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      itemCount: rounds.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        RoundModel roundModel = rounds[index];
        return ListItem(
          roundModel: roundModel,
        );
      },
    );
  }
}
