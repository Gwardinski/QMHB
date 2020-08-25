import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/questions/user_question_collection.dart';
import 'package:qmhb/screens/library/rounds/user_rounds_sidebar.dart';
import 'package:qmhb/screens/library/questions/question_editor.dart';

class QuestionCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Questions"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionEditorPage(
                      type: QuestionEditorType.ADD,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            UserRoundsSidebar(),
            Expanded(
              child: UserQuestionsCollection(),
            ),
          ],
        ),
      ),
    );
  }
}
