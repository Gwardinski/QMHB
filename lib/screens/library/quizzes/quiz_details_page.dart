import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/details/quiz_details_widget.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizDetailsPage extends StatefulWidget {
  final QuizModel quizModel;

  QuizDetailsPage({
    @required this.quizModel,
  });

  @override
  _QuizDetailsPageState createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  QuizModel quiz;

  @override
  void initState() {
    quiz = widget.quizModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quiz Details"),
        actions: <Widget>[
          QuizListItemAction(
            quizModel: widget.quizModel,
            emitData: (newQuiz) {
              setState(() {
                quiz = newQuiz;
              });
            },
          )
        ],
      ),
      body: QuizDetailsWidget(
        quizModel: widget.quizModel,
      ),
    );
  }
}
