import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/TitleAndDetailsBlock.dart';

class QuestionDetailsWidget extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleAndDetailsBlock(
            title: questionModel.question,
            description: questionModel.answer,
            item1Title: 'Points',
            item1Text: questionModel.points.toString(),
          ),
        ],
      ),
    );
  }
}
