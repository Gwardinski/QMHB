import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class RoundReorderQuestions extends StatefulWidget {
  final RoundModel round;
  final Function onReorder;

  RoundReorderQuestions({
    @required this.round,
    @required this.onReorder,
  });

  @override
  _RoundReorderQuestionsState createState() => _RoundReorderQuestionsState();
}

class _RoundReorderQuestionsState extends State<RoundReorderQuestions>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  reorder(int oldIndex, int newIndex) {
    var updatedRound = widget.round;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = updatedRound.questions.removeAt(oldIndex);
    final QuestionModel question = updatedRound.questionModels.removeAt(oldIndex);
    updatedRound.questions.insert(newIndex, q);
    updatedRound.questionModels.insert(newIndex, question);
    widget.onReorder(updatedRound);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ReorderableListView(
      onReorder: reorder,
      children: widget.round.questionModels
          .map(
            (question) => QuestionListItemShell(
              key: Key(question.id.toString()),
              question: question,
            ),
          )
          .toList(),
    );
  }
}
