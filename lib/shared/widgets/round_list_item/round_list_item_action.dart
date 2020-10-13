import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/rounds/add_round_to_quiz_dialog/add_round_to_quiz_dialog.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class RoundListItemAction extends StatefulWidget {
  const RoundListItemAction({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final roundModel;

  @override
  _RoundListItemActionState createState() => _RoundListItemActionState();
}

class _RoundListItemActionState extends State<RoundListItemAction> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<RoundOptions>(
          padding: EdgeInsets.zero,
          tooltip: "Round Actions",
          onSelected: (result) async {
            await onMenuSelect(result);
          },
          child: Container(
            width: 64,
            height: 64,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<RoundOptions>>[
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.addToQuiz,
              child: Row(
                children: <Widget>[
                  Icon(Icons.file_upload),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Add Round to Quiz'),
                ],
              ),
            ),
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.edit,
              child: Row(
                children: <Widget>[
                  Icon(Icons.edit),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Edit Round Details'),
                ],
              ),
            ),
            PopupMenuItem<RoundOptions>(
              value: RoundOptions.delete,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Padding(padding: EdgeInsets.only(left: 16)),
                  Text('Delete Round'),
                ],
              ),
            ),
            // PopupMenuItem<RoundOptions>(
            //   value: RoundOptions.save,
            //   child: Text("Save To Collection"),
            // ),
            // PopupMenuItem<RoundOptions>(
            //   value: RoundOptions.publish,
            //   child: Text("Publish"),
            // ),
          ],
        ),
      ),
    );
  }

  onMenuSelect(RoundOptions result) async {
    if (result == RoundOptions.addToQuiz) {
      return _addRoundToRound();
    }
    if (result == RoundOptions.edit) {
      return await _editRound();
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

  _addRoundToRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddRoundToQuizDialog(
          roundModel: widget.roundModel,
        );
      },
    );
  }

  _editRound() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundEditorPage(
          type: RoundEditorType.EDIT,
          roundModel: widget.roundModel,
        ),
      ),
    );
  }

  _deleteRound() {
    var text = "Are you sure you wish to delete ${widget.roundModel.title} ?";
    if (widget.roundModel.questionIds.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.roundModel.questionIds.length} questions this round contains.";
    }
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Delete Round"),
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
