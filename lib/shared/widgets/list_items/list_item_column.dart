import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

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
        return QuizListItem(
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
        return RoundListItem(
          roundModel: roundModel,
        );
      },
    );
  }
}
