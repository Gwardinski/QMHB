import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_line1.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_line2.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_line3.dart';

class QuizListItemDetails extends StatelessWidget {
  const QuizListItemDetails({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuizListItemLine1(
            text: quizModel.title,
          ),
          QuizListItemLine2(
            description: quizModel.description,
          ),
          QuizListItemLine3(
            points: quizModel.totalPoints.toString(),
            rounds: quizModel.roundIds.length.toString(),
            questions: quizModel.questionIds.length.toString(),
          ),
        ],
      ),
    );
  }
}
