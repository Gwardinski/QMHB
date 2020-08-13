import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/screens/library/widgets/quiz_editor.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
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
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            IgnorePointer(
              child: SummaryTile(
                line1: widget.quizModel.title,
                line2: "Rounds",
                line2Value: widget.quizModel.roundIds.length,
                line3: "Points",
                line3Value: widget.quizModel.totalPoints,
                onTap: () {},
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
            ),
            Expanded(
              child: Container(
                height: 128,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.quizModel.description)),
                  ],
                ),
              ),
            ),
            QuizListItemAction(
              onTap: onMenuSelect,
            ),
          ],
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
          type: QuizEditorType.EDIT,
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
    // TODO save pre-existing question
    print("Save Question");
  }

  _publishRound() {
    // TODO publish question
    print("Publish Question");
  }
}
