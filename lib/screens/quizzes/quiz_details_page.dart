import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/quizzes/quiz_details_widget.dart';
import 'package:qmhb/screens/quizzes/quiz_edit_page.dart';

class QuizDetailsPage extends StatelessWidget {
  final QuizModel quizModel;

  QuizDetailsPage({
    @required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Details"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.edit),
            label: Text('Edit'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizEditPage(quizModel: quizModel),
                ),
              );
            },
          ),
        ],
      ),
      body: QuizDetailsWidget(
        quizModel: quizModel,
      ),
    );
  }
}
