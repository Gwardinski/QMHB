import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/highlights/no_quiz_or_round_widget.dart';
import 'package:qmhb/shared/widgets/list_items/quiz_list_item.dart';

class CreatedQuizzesCollection extends StatelessWidget {
  CreatedQuizzesCollection({
    Key key,
    @required this.userQuizzes,
  }) : super(key: key);

  final userQuizzes;

  @override
  Widget build(BuildContext context) {
    return userQuizzes.length > 0
        ? ListView.builder(
            itemCount: userQuizzes.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              QuizModel quizModel = userQuizzes[index];
              return QuizListItem(
                quizModel: quizModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.only(top: 16),
            child: NoQuizOrRoundWidget(type: NoQuizOrRoundWidgetType.QUIZ),
          );
  }
}
