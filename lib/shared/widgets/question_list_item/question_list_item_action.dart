import 'package:flutter/material.dart';
import 'package:qmhb/pages/library/add_question_to_rounds_page.dart';
import 'package:qmhb/pages/library/questions/question_delete_dialog.dart';
import 'package:qmhb/pages/library/questions/editor/question_editor_page.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/services/navigation_service.dart';

enum QuestionOptions { save, edit, delete, details, addToRound, publish }

class QuestionListItemAction extends StatefulWidget {
  const QuestionListItemAction({
    Key key,
    @required this.question,
  }) : super(key: key);

  final question;

  @override
  _QuestionListItemActionState createState() => _QuestionListItemActionState();
}

class _QuestionListItemActionState extends State<QuestionListItemAction> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Material(
            color: Colors.transparent,
            child: PopupMenuButton<QuestionOptions>(
              padding: EdgeInsets.zero,
              tooltip: "Question Actions",
              onSelected: (result) {
                onMenuSelect(result);
              },
              child: Container(
                width: 48,
                height: 48,
                child: Icon(Icons.more_vert),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<QuestionOptions>>[
                PopupMenuItem<QuestionOptions>(
                  value: QuestionOptions.addToRound,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.playlist_add),
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Text('Add Question to Rounds'),
                    ],
                  ),
                ),
                PopupMenuItem<QuestionOptions>(
                  value: QuestionOptions.edit,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.edit),
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Text('Edit Question'),
                    ],
                  ),
                ),
                PopupMenuItem<QuestionOptions>(
                  value: QuestionOptions.delete,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Text('Delete Question'),
                    ],
                  ),
                ),
                // PopupMenuItem<QuestionOptions>(
                //   value: QuestionOptions.save,
                //   child: Text("Save To Collection"),
                // ),
                // PopupMenuItem<QuestionOptions>(
                //   value: QuestionOptions.publish,
                //   child: Text("Publish"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onMenuSelect(QuestionOptions result) async {
    switch (result) {
      case QuestionOptions.addToRound:
        return _addToRounds();
      case QuestionOptions.edit:
        return _editQuestion();
      case QuestionOptions.delete:
        return _deleteQuestion();
      case QuestionOptions.save:
        return _saveQuestion();
      case QuestionOptions.publish:
        return _publishQuestion();
      default:
        print("Unknown Question Action");
    }
  }

  void _addToRounds() {
    Provider.of<NavigationService>(context, listen: false).push(
      AddQuestionToRoundsPage(
        selectedQuestion: widget.question,
      ),
    );
  }

  void _editQuestion() {
    Provider.of<NavigationService>(context, listen: false).push(
      QuestionEditorPage(
        question: widget.question,
      ),
    );
  }

  _deleteQuestion() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDeleteDialog(
          question: widget.question,
        );
      },
    );
  }

  _saveQuestion() {
    print("Save Question");
  }

  _publishQuestion() {
    print("Publish Question");
  }
}
