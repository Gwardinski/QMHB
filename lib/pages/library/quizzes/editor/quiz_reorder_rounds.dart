import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class QuizReorderRounds extends StatefulWidget {
  final QuizModel quiz;
  final Function onReorder;

  QuizReorderRounds({
    @required this.quiz,
    @required this.onReorder,
  });

  @override
  _QuizReorderRoundsState createState() => _QuizReorderRoundsState();
}

class _QuizReorderRoundsState extends State<QuizReorderRounds> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  reorder(int oldIndex, int newIndex) {
    var updatedQuiz = widget.quiz;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = updatedQuiz.rounds.removeAt(oldIndex);
    final RoundModel round = updatedQuiz.roundModels.removeAt(oldIndex);
    updatedQuiz.rounds.insert(newIndex, q);
    updatedQuiz.roundModels.insert(newIndex, round);
    widget.onReorder(updatedQuiz);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.quiz.roundModels.length > 0
        ? ReorderableListView(
            onReorder: reorder,
            children: widget.quiz.roundModels
                .map(
                  (round) => RoundListItem(
                    key: Key(round.id.toString()),
                    round: round,
                  ),
                )
                .toList(),
          )
        : Container(
            child: Center(
              child: Text("You have not selected any Rounds yet"),
            ),
          );
  }
}
