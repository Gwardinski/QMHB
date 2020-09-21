import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line1.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line2.dart';

class QuestionListItemDetails extends StatelessWidget {
  const QuestionListItemDetails({
    Key key,
    @required this.revealAnswer,
    @required this.questionModel,
  }) : super(key: key);

  final bool revealAnswer;
  final QuestionModel questionModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionListItemLine1(
            text: revealAnswer == true ? questionModel.answer : questionModel.question,
            highlight: revealAnswer,
          ),
          QuestionListItemLine2(
            points: questionModel.points.toString(),
            category: questionModel.category,
          ),
        ],
      ),
    );
  }
}
