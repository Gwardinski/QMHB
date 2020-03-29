import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/questions/add_question_widgets/round_selector.dart';

class RoundSelectorWidget extends StatefulWidget {
  final List<RoundModel> rounds;
  final String questionId;
  final double questionPoints;
  RoundSelectorWidget({
    @required this.rounds,
    @required this.questionId,
    @required this.questionPoints,
  });

  @override
  _RoundSelectorWidgetState createState() => _RoundSelectorWidgetState();
}

class _RoundSelectorWidgetState extends State<RoundSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.rounds?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          RoundModel roundModel = widget.rounds[index];
          return RoundSelector(
            roundModel: roundModel,
            questionId: widget.questionId,
            questionPoints: widget.questionPoints,
          );
        },
      ),
    );
  }
}
