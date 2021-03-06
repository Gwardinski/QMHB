import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/question/question_details_dialog.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_action2.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item_details.dart';

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
      feedback: DragFeedback(
        title: questionModel.question,
      ),
      child: QuestionListItem(
        questionModel: questionModel,
      ),
    );
  }
}

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
            QuestionListItemAction2(
              revealAnswer: revealAnswer,
              type: widget.questionModel.questionType,
              onTap: _updateRevealAnswer,
            ),
            QuestionListItemDetails(
              revealAnswer: revealAnswer,
              questionModel: widget.questionModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
              child: QuestionListItemAction(
                questionModel: widget.questionModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
