import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';

class QuizListItemsColumn extends StatelessWidget {
  final List<QuizModel> quizzes;

  const QuizListItemsColumn({
    this.quizzes,
  });

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
