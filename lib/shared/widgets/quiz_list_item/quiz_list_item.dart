import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

enum QuizOptions { save, edit, delete, details, addToRound, publish }

class QuizListItem extends StatefulWidget {
  const QuizListItem({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  _QuizListItemState createState() => _QuizListItemState();
}

class _QuizListItemState extends State<QuizListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizDetailsPage(
              quizModel: widget.quizModel,
            ),
          ),
        );
      },
      child: SummaryTileLarge(
        line1: widget.quizModel.title,
        line2: "Questions",
        line2Value: widget.quizModel.questionIds.length,
        line3: "Points",
        line3Value: widget.quizModel.totalPoints,
        description: widget.quizModel.description,
        actionButton: QuizListItemAction(
          onTap: onMenuSelect,
        ),
      ),
    );
  }

  onMenuSelect(QuizOptions result) {
    if (result == QuizOptions.edit) {
      return _editRound();
    }
    if (result == QuizOptions.delete) {
      return _deleteRound();
    }
    if (result == QuizOptions.save) {
      return _saveRound();
    }
    if (result == QuizOptions.publish) {
      return _publishRound();
    }
  }

  _editRound() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizEditorPage(
          quizModel: widget.quizModel,
        ),
      ),
    );
  }

  _deleteRound() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Are you sure you wish to delete this quiz ?"),
        content: Text(widget.quizModel.title),
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
              await Provider.of<QuizCollectionService>(context).deleteQuizOnFirebaseCollection(
                widget.quizModel.id,
              );
            },
          ),
        ],
      ),
    );
  }

  _saveRound() {
    print("Save Quiz");
  }

  _publishRound() {
    print("Publish Quiz");
  }
}
