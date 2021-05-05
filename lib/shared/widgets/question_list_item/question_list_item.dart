import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/pages/details/question/question_details_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_favourite.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_reveal_button.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_details.dart';

class QuestionListItemWithAction extends StatefulWidget {
  final QuestionModel question;

  QuestionListItemWithAction({
    Key key,
    @required this.question,
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
          question: widget.question,
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
              type: widget.question.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              question: widget.question,
            ),
            QuestionListItemFavourite(
              question: widget.question,
              isDisabled: false,
            ),
            QuestionListItemAction(
              question: widget.question,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionListItemWithSelect extends StatefulWidget {
  final QuestionModel question;
  final Function containsItem;
  final Function onTap;

  QuestionListItemWithSelect({
    Key key,
    @required this.question,
    @required this.containsItem,
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
          question: widget.question,
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
              type: widget.question.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              question: widget.question,
            ),
            QuestionListItemFavourite(
              question: widget.question,
              isDisabled: true,
            ),
            // TODO move logi into widget. Seperate UI to be reusable
            AddItemIntoItemButton(
              contains: widget.containsItem,
              onTap: widget.onTap,
            )
          ],
        ),
      ),
    );
  }
}

class QuestionListItemWithSelectAndReorder extends StatefulWidget {
  final QuestionModel question;
  final Function containsItem;
  final Function onTap;

  QuestionListItemWithSelectAndReorder({
    Key key,
    @required this.question,
    @required this.containsItem,
    @required this.onTap,
  }) : super(key: key);

  @override
  _QuestionListItemWithSelectAndReorderState createState() =>
      _QuestionListItemWithSelectAndReorderState();
}

class _QuestionListItemWithSelectAndReorderState
    extends State<QuestionListItemWithSelectAndReorder> {
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
          question: widget.question,
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
        padding: EdgeInsets.only(right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuestionListItemRevealButton(
              revealAnswer: revealAnswer,
              type: widget.question.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: false,
              question: widget.question,
            ),
            // TODO move logi into widget. Seperate UI to be reusable
            AddItemIntoItemButton(
              contains: widget.containsItem,
              onTap: widget.onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionListItemInRoundDialog extends StatefulWidget {
  final QuestionModel question;

  QuestionListItemInRoundDialog({
    Key key,
    @required this.question,
  }) : super(key: key);

  @override
  _QuestionListItemInRoundDialogState createState() => _QuestionListItemInRoundDialogState();
}

class _QuestionListItemInRoundDialogState extends State<QuestionListItemInRoundDialog> {
  bool revealAnswer = false;

  void _updateRevealAnswer() {
    setState(() {
      revealAnswer = !revealAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionListItemRevealButton(
            revealAnswer: revealAnswer,
            type: widget.question.questionType,
            onTap: _updateRevealAnswer,
          ),
          QuestionListItemDetails(
            revealAnswer: revealAnswer,
            question: widget.question,
          ),
          Container(width: 8),
        ],
      ),
    );
  }
}

class DraggableQuestionListItem extends StatelessWidget {
  final QuestionModel question;
  final Function onDragStarted;
  final Function onDragEnd;

  DraggableQuestionListItem({
    Key key,
    @required this.question,
    @required this.onDragStarted,
    @required this.onDragEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<QuestionModel>(
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      dragAnchor: DragAnchor.pointer,
      data: question,
      feedback: QuestionListItemDragFeedback(
        question: question,
      ),
      child: QuestionListItemWithAction(
        question: question,
      ),
    );
  }
}

class QuestionListItemDragFeedback extends StatelessWidget {
  final QuestionModel question;

  QuestionListItemDragFeedback({
    Key key,
    @required this.question,
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
              question: question,
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
