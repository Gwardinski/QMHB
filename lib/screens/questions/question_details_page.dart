import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/questions/question_details_widget.dart';
import 'package:qmhb/screens/questions/question_edit_page.dart';
import 'package:qmhb/screens/questions/question_round_selector_page.dart';

class QuestionDetailsPage extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsPage({
    @required this.questionModel,
  });

  @override
  Widget build(BuildContext context) {
    print("QuestionDetailsPage");
    return Scaffold(
      appBar: AppBar(
        title: Text("Question"),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionEditPage(questionModel: questionModel),
                ),
              );
            },
          ),
          FlatButton(
            child: Text('Add to'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionToRoundSelectorPage(
                    questionId: questionModel.uid,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: QuestionDetailsWidget(
        questionModel: questionModel,
      ),
    );
  }
}
