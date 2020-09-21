import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/questions/question_editor.dart';
import 'package:qmhb/screens/library/rounds/add_question_to_round.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_details.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action2.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_details.dart';

enum QuestionOptions { save, edit, delete, details, addToRound, publish }

class QuestionListItem extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionListItem({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  bool revealAnswer = false;

  void updateRevealAnswer() {
    setState(() {
      revealAnswer = !revealAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<QuestionModel>(
      dragAnchor: DragAnchor.pointer,
      data: widget.questionModel,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 64,
          width: 256,
          color: Colors.grey,
          child: Center(
            child: Text(
              widget.questionModel.question,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onTap: _viewQuestionDetails,
        child: Container(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                child: QuestionListItemAction2(
                  revealAnswer: revealAnswer,
                  onTap: updateRevealAnswer,
                ),
              ),
              QuestionListItemDetails(
                revealAnswer: revealAnswer,
                questionModel: widget.questionModel,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                child: QuestionListItemAction(
                  onTap: onMenuSelect,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewQuestionDetails() {
    showDialog(
      context: context,
      child: QuestionDetails(
        questionModel: widget.questionModel,
        editQuestion: _editQuestion,
        addQuestionToRound: _addQuestionToRound,
        deleteQuestion: _deleteQuestion,
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
