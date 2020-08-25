import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:responsive_grid/responsive_grid.dart';

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
          return QuizListItem(
            quizModel: quizModel,
          );
        }).toList(),
      ),
    );
  }
}
