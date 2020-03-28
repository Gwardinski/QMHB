import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/rounds/add_round_widgets/quiz_selector.dart';

class QuizSelectorWidget extends StatefulWidget {
  final List<QuizModel> quizzes;
  final String roundId;
  QuizSelectorWidget({
    @required this.quizzes,
    @required this.roundId,
  });

  @override
  _QuizSelectorWidgetState createState() => _QuizSelectorWidgetState();
}

class _QuizSelectorWidgetState extends State<QuizSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.quizzes?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          QuizModel quizModel = widget.quizzes[index];
          return QuizSelector(
            quizModel: quizModel,
            roundId: widget.roundId,
          );
        },
      ),
    );
  }
}
