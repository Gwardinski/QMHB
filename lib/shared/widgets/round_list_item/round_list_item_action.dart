import 'package:flutter/material.dart';
import 'package:qmhb/pages/library/add_round_to_quizzes_page.dart';
import 'package:qmhb/pages/library/rounds/round_delete_dialog.dart';
import 'package:qmhb/pages/library/rounds/round_editor_page.dart';

enum RoundOptions { save, edit, delete, details, addToQuiz, publish }

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
    switch (result) {
      case RoundOptions.addToQuiz:
        return _addToQuizzes();
      case RoundOptions.edit:
        return _editRound();
      case RoundOptions.delete:
        return _deleteRound();
      case RoundOptions.save:
        return _saveRound();
      case RoundOptions.publish:
        return _publishRound();
      default:
        print("Unknown Question Action");
    }
  }

  void _addToQuizzes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddRoundToQuizzesPage(selectedRound: widget.roundModel),
      ),
    );
  }

  void _editRound() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundEditorPage(
          type: RoundEditorType.EDIT,
          roundModel: widget.roundModel,
        ),
      ),
    );
  }

  _deleteRound() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RoundDeleteDialog(
          roundModel: widget.roundModel,
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
