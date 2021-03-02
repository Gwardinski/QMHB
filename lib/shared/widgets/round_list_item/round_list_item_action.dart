import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/round_service.dart';
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
                  Icon(Icons.playlist_add),
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
      return _addRoundToQuiz();
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

  _addRoundToQuiz() {
    // showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AddRoundToQuizDialog(
    //       roundModel: widget.roundModel,
    //     );
    //   },
    // );
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
    if (widget.roundModel.questions.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.roundModel.questions.length} questions this round contains.";
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Round"),
          content: Text(text),
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
                Navigator.of(context).pop();
                final token = Provider.of<UserDataStateModel>(context, listen: false).token;
                await Provider.of<RoundService>(context, listen: false).deletetRound(
                  round: widget.roundModel,
                  token: token,
                );
              },
            ),
          ],
        );
      },
    );
  }

  _saveRound() {
    print("Save Round");
  }

  _publishRound() {
    print("Publish Round");
  }
}
