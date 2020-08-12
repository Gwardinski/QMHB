import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/questions/round_selector/round_selector_page.dart';
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
    return InkWell(
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
    );
  }

  _viewQuestionDetails() {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(widget.questionModel.question),
        content: Text(widget.questionModel.answer),
        actions: [
          FlatButton(
            child: const Text('Add To Round'),
            onPressed: _addQuestionToRound,
          ),
          FlatButton(
            child: const Text('Edit'),
            onPressed: _editQuestion,
          ),
          FlatButton(
            child: const Text('Delete'),
            onPressed: _deleteQuestion,
          ),
          // FlatButton(
          //   child: const Text('Publish'),
          //   onPressed: _publishQuestion,
          // ),
          // FlatButton(
          //   child: const Text('Save'),
          //   onPressed: _deleteQuestion,
          // ),
        ],
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
    if (result == QuestionOptions.details) {
      return _viewQuestionDetails();
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
    // TODO delete own questions only
    print("Delete Question");
  }

  _saveQuestion() {
    // TODO save pre-existing question
    print("Save Question");
  }

  _publishQuestion() {
    // TODO publish question
    print("Publish Question");
  }
}
