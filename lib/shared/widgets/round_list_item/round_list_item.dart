import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/add_round_to_quiz.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_details.dart';

enum RoundOptions { save, edit, delete, details, addToQuiz, publish }

class RoundListItem extends StatefulWidget {
  final RoundModel roundModel;

  RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

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
        onTap: _viewRoundDetails,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
              ),
              RoundListItemDetails(
                roundModel: widget.roundModel,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                child: RoundListItemAction(
                  onTap: onMenuSelect,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewRoundDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundDetailsPage(
          roundModel: widget.roundModel,
        ),
      ),
    );
  }

  onMenuSelect(RoundOptions result) {
    if (result == RoundOptions.addToQuiz) {
      return _addRoundToRound();
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

  _addRoundToRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddRoundToQuizPage(
          roundModel: widget.roundModel,
        );
      },
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
