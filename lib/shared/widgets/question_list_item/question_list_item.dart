import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_details.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action2.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_details.dart';

enum QuestionOptions { save, edit, delete, details, addToRound, publish }

class QuestionListItem extends StatefulWidget {
  final QuestionModel questionModel;
  final bool canDrag;

  QuestionListItem({
    Key key,
    @required this.questionModel,
    this.canDrag = false,
  }) : super(key: key);

  @override
  _QuestionListItemState createState() => _QuestionListItemState();
}

class _QuestionListItemState extends State<QuestionListItem> {
  bool revealAnswer = false;

  @override
  Widget build(BuildContext context) {
    final listItemContent = QuestionListItemContent(
      revealAnswer: revealAnswer,
      questionModel: widget.questionModel,
      viewQuestionDetails: _viewQuestionDetails,
      updateRevealAnswer: _updateRevealAnswer,
    );
    return widget.canDrag
        ? Draggable<QuestionModel>(
            dragAnchor: DragAnchor.pointer,
            data: widget.questionModel,
            feedback: DragFeedback(
              title: widget.questionModel.question,
            ),
            child: listItemContent,
          )
        : listItemContent;
  }

  void _updateRevealAnswer() {
    setState(() {
      revealAnswer = !revealAnswer;
    });
  }

  void _viewQuestionDetails() {
    showDialog(
      context: context,
      child: QuestionDetails(
        questionModel: widget.questionModel,
      ),
    );
  }
}

class QuestionListItemContent extends StatelessWidget {
  const QuestionListItemContent({
    Key key,
    @required this.revealAnswer,
    @required this.questionModel,
    @required this.viewQuestionDetails,
    @required this.updateRevealAnswer,
  }) : super(key: key);

  final bool revealAnswer;
  final QuestionModel questionModel;
  final viewQuestionDetails;
  final updateRevealAnswer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewQuestionDetails();
      },
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
                onTap: () {
                  updateRevealAnswer();
                },
              ),
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              questionModel: questionModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
              child: QuestionListItemAction(
                questionModel: questionModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
