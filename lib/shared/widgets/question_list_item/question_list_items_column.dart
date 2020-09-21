import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class QuestionListItemsColumn extends StatelessWidget {
  final List<QuestionModel> questions;
  final canDrag;

  const QuestionListItemsColumn({
    this.questions,
    this.canDrag = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      itemCount: questions.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        QuestionModel questionModel = questions[index];
        return QuestionListItem(
          questionModel: questionModel,
          canDrag: canDrag,
        );
      },
    );
  }
}
