import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line1.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line2.dart';

class QuestionListItemDetails extends StatelessWidget {
  const QuestionListItemDetails({
    Key key,
    @required this.revealAnswer,
    @required this.question,
  }) : super(key: key);

  final bool revealAnswer;
  final QuestionModel question;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionListItemLine1(
            text: revealAnswer == true ? question.answer : question.question,
            highlight: revealAnswer,
          ),
          QuestionListItemLine2(
            points: question.points.toString(),
            category: question.category,
          ),
        ],
      ),
    );
  }
}
