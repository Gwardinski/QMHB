import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';

class QuestionDetailsWidget extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsWidget({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    print(user.lastUpdated);
    return Column(
      children: [
        Text(questionModel.question),
      ],
    );
  }
}
