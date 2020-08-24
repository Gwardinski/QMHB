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
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoundDetailsPage(
              roundModel: widget.roundModel,
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
                line1: widget.roundModel.title,
                line2: "Questions",
                line2Value: widget.roundModel.questionIds.length,
                line3: "Points",
                line3Value: widget.roundModel.totalPoints,
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
                    Expanded(child: Text(widget.roundModel.description)),
                  ],
                ),
              ),
            ),
            RoundListItemAction(
              onTap: onMenuSelect,
            ),
          ],
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
