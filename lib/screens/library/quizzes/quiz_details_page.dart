import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/shared/widgets/details/quiz_details_widget.dart';

class QuizDetailsPage extends StatelessWidget {
  final QuizModel quizModel;

  QuizDetailsPage({
    @required this.quizModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quiz Details"),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizEditorPage(
                    quizModel: quizModel,
                  ),
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
