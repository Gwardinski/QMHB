import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';

class QuizDeleteDialog extends StatelessWidget {
  final QuizModel quizModel;

  QuizDeleteDialog({@required this.quizModel});

  @override
  Widget build(BuildContext context) {
    var text = "Are you sure you wish to delete ${quizModel.title} ?";
    if (quizModel.rounds.length > 0) {
      text += "\n\nThis will not delete the ${quizModel.rounds.length} rounds this quiz contains.";
    }
    // if (quizModel.noOfQuestions > 0) {
    //   text +=
    //       "\n\nThis will not delete the ${quizModel.noOfQuestions} questions this quiz contains.";
    // }
    return AlertDialog(
      title: Text("Delete Quiz"),
      content: Text(text),
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
            Navigator.of(context).pop();
            final token = Provider.of<UserDataStateModel>(context, listen: false).token;
            await Provider.of<QuizService>(context, listen: false).deleteQuiz(
              quiz: quizModel,
              token: token,
            );
            Provider.of<RefreshService>(context, listen: false).quizRefresh();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
