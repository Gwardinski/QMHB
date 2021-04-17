import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';

enum QuizOptions { save, edit, delete, details, addToQuiz, publish }

class QuizListItemAction extends StatefulWidget {
  const QuizListItemAction({
    Key key,
    @required this.quiz,
  }) : super(key: key);

  final quiz;

  @override
  _QuizListItemActionState createState() => _QuizListItemActionState();
}

class _QuizListItemActionState extends State<QuizListItemAction> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<QuizOptions>(
          padding: EdgeInsets.zero,
          tooltip: "Quiz Actions",
          onSelected: (result) async {
            await onMenuSelect(result);
          },
          child: Container(
            width: 48,
            height: 48,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<QuizOptions>>[
            PopupMenuItem<QuizOptions>(
              value: QuizOptions.edit,
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Edit Quiz'),
                ],
              ),
            ),
            PopupMenuItem<QuizOptions>(
              value: QuizOptions.delete,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Delete Quiz'),
                ],
              ),
            ),
            // PopupMenuItem<QuizOptions>(
            //   value: QuizOptions.save,
            //   child: Text("Save To Collection"),
            // ),
            // PopupMenuItem<QuizOptions>(
            //   value: QuizOptions.publish,
            //   child: Text("Publish"),
            // ),
          ],
        ),
      ),
    );
  }

  onMenuSelect(QuizOptions result) async {
    if (result == QuizOptions.edit) {
      return await _editQuiz();
    }
    if (result == QuizOptions.delete) {
      return _deleteQuiz();
    }
    if (result == QuizOptions.save) {
      return _saveQuiz();
    }
    if (result == QuizOptions.publish) {
      return _publishQuiz();
    }
  }

  _editQuiz() async {
    Provider.of<NavigationService>(context, listen: false).push(
      QuizEditorPage(
        quiz: widget.quiz,
      ),
    );
  }

  _deleteQuiz() {
    var text = "Are you sure you wish to delete ${widget.quiz.title} ?";
    if (widget.quiz.rounds.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.quiz.rounds.length} rounds this quiz contains.";
    }
    // if (widget.quiz.noOfQuestions > 0) {
    //   text +=
    //       "\n\nThis will not delete the ${widget.quiz.noOfQuestions} questions this quiz contains.";
    // }
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                Provider.of<NavigationService>(context, listen: false).pop();
                final token = Provider.of<UserDataStateModel>(context, listen: false).token;
                await Provider.of<QuizService>(context, listen: false).deleteQuiz(
                  quiz: widget.quiz,
                  token: token,
                );
              },
            ),
          ],
        );
      },
    );
  }

  _saveQuiz() {
    print("Save Quiz");
  }

  _publishQuiz() {
    print("Publish Quiz");
  }
}
