import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';

class QuizListItemAction extends StatefulWidget {
  const QuizListItemAction({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final quizModel;

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
            width: 64,
            height: 64,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<QuizOptions>>[
            PopupMenuItem<QuizOptions>(
              value: QuizOptions.edit,
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Edit Quiz Details'),
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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizEditorPage(
          quizModel: widget.quizModel,
        ),
      ),
    );
  }

  _deleteQuiz() {
    var text = "Are you sure you wish to delete ${widget.quizModel.title} ?";
    if (widget.quizModel.roundIds.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.quizModel.roundIds.length} rounds this quiz contains.";
    }
    if (widget.quizModel.questionIds.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.quizModel.questionIds.length} questions this quiz contains.";
    }
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Delete Quiz"),
        content: Text(text),
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
              await Provider.of<QuizCollectionService>(context)
                  .deleteQuizOnFirebaseCollection(widget.quizModel.id);
            },
          ),
        ],
      ),
    );
  }

  _saveQuiz() {
    print("Save Quiz");
  }

  _publishQuiz() {
    print("Publish Quiz");
  }
}
