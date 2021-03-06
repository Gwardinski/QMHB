import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';

class QuestionDeleteDialog extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDeleteDialog({this.questionModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Question"),
      content: Text("Are you sure you wish to delete ${questionModel.question} ?"),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () async {
            try {
              final token = Provider.of<UserDataStateModel>(context, listen: false).token;
              await Provider.of<QuestionService>(context, listen: false).deleteQuestion(
                question: questionModel,
                token: token,
              );
              Provider.of<RefreshService>(context, listen: false).roundAndQuestionRefresh();
              Navigator.of(context).pop();
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }
}
