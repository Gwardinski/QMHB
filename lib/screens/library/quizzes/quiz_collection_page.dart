import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/quizzes/quiz_add_modal.dart';
import 'package:qmhb/screens/library/quizzes/user_quizzes_collection.dart';

class QuizCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Quizzes"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return QuizAddModal();
                  },
                );
              },
            ),
          ],
        ),
        body: UserQuizzesCollection(),
      ),
    );
  }
}
