import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';

class QuizDeleteDialog extends StatelessWidget {
  final QuizModel quiz;

  QuizDeleteDialog({@required this.quiz});

  @override
  Widget build(BuildContext context) {
    var text = "Are you sure you wish to delete ${quiz.title} ?";
    if (quiz.rounds.length > 0) {
      text += "\n\nThis will not delete the ${quiz.rounds.length} rounds this quiz contains.";
    }
    // if (quiz.noOfQuestions > 0) {
    //   text +=
    //       "\n\nThis will not delete the ${quiz.noOfQuestions} questions this quiz contains.";
    // }
    return AlertDialog(
      title: Text("Delete Quiz"),
      content: Text(text),
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
            final token = Provider.of<UserDataStateModel>(context, listen: false).token;
            await Provider.of<QuizService>(context, listen: false).deleteQuiz(
              quiz: quiz,
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
