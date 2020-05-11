import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/shared/widgets/quiz_details_widget.dart';

class QuizDetailsPage extends StatefulWidget {
  final QuizModel quizModel;

  QuizDetailsPage({
    @required this.quizModel,
  });

  @override
  _QuizDetailsPageState createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  QuizModel quizModel;

  @override
  void initState() {
    super.initState();
    quizModel = widget.quizModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Details"),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            onPressed: () async {
              final quiz = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizEditorPage(
                    type: QuizEditorPageType.EDIT,
                    quizModel: quizModel,
                  ),
                ),
              );
              setState(() {
                quizModel = quiz;
              });
            },
          ),
        ],
      ),
      body: QuizDetailsWidget(
        quizModel: widget.quizModel,
      ),
    );
  }
}
