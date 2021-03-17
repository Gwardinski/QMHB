import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/pages/details/question/question_details_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_reveal_button.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_details.dart';

class QuestionListItemWithAction extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionListItemWithAction({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  _QuestionListItemWithActionState createState() => _QuestionListItemWithActionState();
}

class _QuestionListItemWithActionState extends State<QuestionListItemWithAction> {
  bool revealAnswer = false;

  void _updateRevealAnswer() {
    setState(() {
      revealAnswer = !revealAnswer;
    });
  }

  void _viewQuestionDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDetailsDialog(
          questionModel: widget.questionModel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _viewQuestionDetails,
      child: Container(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionListItemRevealButton(
              revealAnswer: revealAnswer,
              type: widget.questionModel.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              questionModel: widget.questionModel,
            ),
            QuestionListItemAction(
              questionModel: widget.questionModel,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionListItemWithSelect extends StatefulWidget {
  final QuestionModel questionModel;
  final RoundModel selectedRound;
  final Function containsQuestion;
  final Function onTap;

  QuestionListItemWithSelect({
    Key key,
    @required this.questionModel,
    @required this.selectedRound,
    @required this.containsQuestion,
    @required this.onTap,
  }) : super(key: key);

  @override
  _QuestionListItemWithSelectState createState() => _QuestionListItemWithSelectState();
}

class _QuestionListItemWithSelectState extends State<QuestionListItemWithSelect> {
  bool revealAnswer = false;

  void _updateRevealAnswer() {
    setState(() {
      revealAnswer = !revealAnswer;
    });
  }

  void _viewQuestionDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuestionDetailsDialog(
          questionModel: widget.questionModel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _viewQuestionDetails,
      child: Container(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionListItemRevealButton(
              revealAnswer: revealAnswer,
              type: widget.questionModel.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              questionModel: widget.questionModel,
            ),
            AddItemIntoItemButton(
              contains: widget.containsQuestion,
              onTap: widget.onTap,
            )
          ],
        ),
      ),
    );
  }
}

class QuestionListItemWithReorder extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionListItemWithReorder({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 64,
          ),
          QuestionListItemDetails(
            revealAnswer: false,
            questionModel: questionModel,
          ),
          Container(
            width: 64,
            height: 64,
          ),
        ],
      ),
    );
  }
}

class DraggableQuestionListItem extends StatelessWidget {
  final QuestionModel questionModel;
  final Function onDragStarted;
  final Function onDragEnd;

  DraggableQuestionListItem({
    Key key,
    @required this.questionModel,
    @required this.onDragStarted,
    @required this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<QuestionModel>(
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      dragAnchor: DragAnchor.pointer,
      data: questionModel,
      feedback: QuestionListItemDragFeedback(
        questionModel: questionModel,
      ),
      child: QuestionListItemWithAction(
        questionModel: questionModel,
      ),
    );
  }
}

class QuestionListItemDragFeedback extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionListItemDragFeedback({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 64,
        width: 320,
        color: Theme.of(context).primaryColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
            ),
            QuestionListItemDetails(
              revealAnswer: false,
              questionModel: questionModel,
            ),
            Container(
              width: 64,
              height: 64,
            ),
          ],
        ),
      ),
    );
  }
}
