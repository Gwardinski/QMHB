import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/quiz_selector/quiz_selector_page.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

enum RoundOptions { save, edit, delete, details, addToRound, publish }

class RoundListItem extends StatefulWidget {
  const RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  _RoundListItemState createState() => _RoundListItemState();
}

class _RoundListItemState extends State<RoundListItem> {
  @override
  Widget build(BuildContext context) {
    return Draggable<RoundModel>(
      dragAnchor: DragAnchor.pointer,
      data: widget.roundModel,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 64,
          width: 256,
          color: Colors.grey,
          child: Center(
            child: Text(
              widget.roundModel.title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoundDetailsPage(
                roundModel: widget.roundModel,
              ),
            ),
          );
        },
        child: SummaryTileLarge(
          line1: widget.roundModel.title,
          line2: "Questions",
          line2Value: widget.roundModel.questionIds.length,
          line3: "Points",
          line3Value: widget.roundModel.totalPoints,
          description: widget.roundModel.description,
          actionButton: RoundListItemAction(
            onTap: onMenuSelect,
          ),
        ),
      ),
    );
  }

  onMenuSelect(RoundOptions result) {
    if (result == RoundOptions.addToRound) {
      return _addRoundToQuiz();
    }
    if (result == RoundOptions.edit) {
      return _editRound();
    }
    if (result == RoundOptions.delete) {
      return _deleteRound();
    }
    if (result == RoundOptions.save) {
      return _saveRound();
    }
    if (result == RoundOptions.publish) {
      return _publishRound();
    }
  }

  _addRoundToQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizSelectorPage(
          round: widget.roundModel,
        ),
      ),
    );
  }

  _editRound() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundEditorPage(
          roundModel: widget.roundModel,
        ),
      ),
    );
  }

  _deleteRound() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Are you sure you wish to delete this round ?"),
        content: Text(widget.roundModel.title),
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
              await Provider.of<RoundCollectionService>(context)
                  .deleteRoundOnFirebaseCollection(widget.roundModel.id);
            },
          ),
        ],
      ),
    );
  }

  _saveRound() {
    print("Save Round");
  }

  _publishRound() {
    print("Publish Round");
  }
}
