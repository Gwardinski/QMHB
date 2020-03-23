import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionDetailsWidget extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(questionModel.question),
      ],
    );
  }
}
