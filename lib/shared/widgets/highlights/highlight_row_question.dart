import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class HighlightRowQuestion extends StatelessWidget {
  final List<QuestionModel> questions;
  const HighlightRowQuestion({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = questions == null ? 0 : questions.length * 112;
    return Container(
      height: (height).toDouble(),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8),
          );
        },
        itemCount: questions?.length ?? 0,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return QuestionListItemWithAction(
            question: questions[index],
          );
        },
      ),
    );
  }
}
