import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/quizzes/quiz_details_widget.dart';

class QuizDetailsPage extends StatelessWidget {
  final QuizModel quizModel;

  QuizDetailsPage({
    @required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quizModel.title),
      ),
      body: QuizDetailsWidget(
        quizModel: quizModel,
      ),
    );
  }
}
