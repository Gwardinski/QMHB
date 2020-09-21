import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/questions/question_editor.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/rounds/add_question_to_round.dart';
import 'package:qmhb/services/question_collection_service.dart';
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
              child: Text("Add Question to Round"),
            ),
            PopupMenuItem<QuestionOptions>(
              value: QuestionOptions.edit,
              child: Text("Edit Question"),
            ),
            PopupMenuItem<QuestionOptions>(
              value: QuestionOptions.delete,
              child: Text("Delete Question"),
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
        return AddQuestionToRoundPage(
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
      child: AlertDialog(
        title: Text("Delete Question"),
        content: Text("Are you sure you wish to delete ${widget.questionModel.question} ?"),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<QuestionCollectionService>(context)
                  .deleteQuestionOnFirebaseCollection(widget.questionModel.id);
            },
          ),
        ],
      ),
    );
  }

  _saveQuestion() {
    print("Save Question");
  }

  _publishQuestion() {
    print("Publish Question");
  }
}
