import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/questions/question_list_item.dart';

class QuestionHighlightRow extends StatelessWidget {
  final List<QuestionModel> questions;
  const QuestionHighlightRow({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = questions == null ? 0 : questions.length * 112;
    return Container(
      height: (height).toDouble(),
      child: ListView.builder(
        itemCount: questions?.length ?? 0,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return QuestionListItem(
            questionModel: questions[index],
          );
        },
      ),
    );
  }
}
