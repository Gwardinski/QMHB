import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';

class QuestionDeleteDialog extends StatelessWidget {
  final QuestionModel question;

  QuestionDeleteDialog({this.question});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete Question"),
      content: Text("Are you sure you wish to delete ${question.question} ?"),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Provider.of<NavigationService>(context, listen: false).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () async {
            try {
              final token = Provider.of<UserDataStateModel>(context, listen: false).token;
              await Provider.of<QuestionService>(context, listen: false).deleteQuestion(
                question: question,
                token: token,
              );
              Provider.of<RefreshService>(context, listen: false).roundAndQuestionRefresh();
              Provider.of<NavigationService>(context, listen: false).pop();
            } catch (e) {
              print(e);
            }
          },
        ),
      ],
    );
  }
}
