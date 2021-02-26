import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/add_question_to_round_dialog/add_question_to_round_dialog.dart';
import 'package:qmhb/pages/library/questions/question_editor_page.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class QuestionListItemAction extends StatefulWidget {
  const QuestionListItemAction({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  final questionModel;

  @override
  _QuestionListItemActionState createState() => _QuestionListItemActionState();
}

class _QuestionListItemActionState extends State<QuestionListItemAction> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
            width: 64,
            height: 64,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<QuestionOptions>>[
            PopupMenuItem<QuestionOptions>(
              value: QuestionOptions.addToRound,
              child: Row(
                children: <Widget>[
                  Icon(Icons.playlist_add),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Add Question to Round'),
                ],
              ),
            ),
            PopupMenuItem<QuestionOptions>(
              value: QuestionOptions.edit,
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Edit Question Details'),
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
    );
  }

  onMenuSelect(QuestionOptions result) {
    if (result == QuestionOptions.addToRound) {
      return _addQuestionToRound();
    }
    if (result == QuestionOptions.edit) {
      return _editQuestion();
    }
    if (result == QuestionOptions.delete) {
      return _deleteQuestion();
    }
    if (result == QuestionOptions.save) {
      return _saveQuestion();
    }
    if (result == QuestionOptions.publish) {
      return _publishQuestion();
    }
  }

  _addQuestionToRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddQuestionToRoundPageDialog(
          questionModel: widget.questionModel,
        );
      },
    );
  }

  _editQuestion() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          type: QuestionEditorType.EDIT,
          questionModel: widget.questionModel,
        ),
      ),
    );
  }

  _deleteQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Question"),
          content: Text("Are you sure you wish to delete ${widget.questionModel.question} ?"),
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
                    question: widget.questionModel,
                    token: token,
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
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
