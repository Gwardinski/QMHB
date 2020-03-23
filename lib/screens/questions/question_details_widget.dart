import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/text_with_title.dart';

class QuestionDetailsWidget extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithTitle(
              title: "Question",
              text: questionModel.question,
            ),
            TextWithTitle(
              title: "Answer",
              text: questionModel.answer,
            ),
            TextWithTitle(
              title: "Points",
              text: questionModel.points.toString(),
              highlighText: true,
            ),
            TextWithTitle(
              title: "Category",
              text: questionModel.category,
              highlighText: true,
            ),
          ],
        ),
      ),
    );
  }
}
