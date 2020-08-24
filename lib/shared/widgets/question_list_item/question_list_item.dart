import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/questions/round_selector/round_selector_page.dart';
import 'package:qmhb/screens/library/widgets/question_editor.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_details.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action2.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line1.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_line2.dart';

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
          padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionListItemAction2(
                revealAnswer: revealAnswer,
                onTap: () {
                  setState(() {
                    revealAnswer = !revealAnswer;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 16),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionListItemLine1(
                      text: revealAnswer == true
                          ? widget.questionModel.answer
                          : widget.questionModel.question,
                      highlight: revealAnswer,
                    ),
                    QuestionListItemLine2(
                      points: widget.questionModel.points.toString(),
                      category: widget.questionModel.category,
                    ),
                  ],
                ),
              ),
              QuestionListItemAction(
                onTap: onMenuSelect,
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundSelectorPage(
          questionId: widget.questionModel.id,
          questionPoints: widget.questionModel.points,
        ),
      ),
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
        title: Text("Are you sure you wish to delete this question ?"),
        content: Text(widget.questionModel.question),
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
