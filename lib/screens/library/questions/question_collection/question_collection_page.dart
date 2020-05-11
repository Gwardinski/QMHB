import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_add_page.dart';
import 'package:qmhb/screens/library/questions/question_collection/created_questions_collection.dart';
import 'package:qmhb/screens/library/questions/question_collection/saved_questions_collection.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuestionCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Questions"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionAddPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: DatabaseService().getQuestionsByIds(user.questionIds),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingSpinnerHourGlass(),
              );
            }
            if (snapshot.hasError == true) {
              return Center(
                child: Text("Could not load content"),
              );
            }
            final userQuestions = snapshot.data
                .where(
                  (QuestionModel qs) => qs.userId == user.uid,
                )
                .toList();
            final savedQuestions = snapshot.data
                .where(
                  (QuestionModel qs) => qs.userId != user.uid,
                )
                .toList();
            return Column(
              children: <Widget>[
                TabBar(
                  tabs: [
                    Tab(child: Text("Created")),
                    Tab(child: Text("Saved")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      CreatedQuestionCollection(userQuestions: userQuestions),
                      SavedQuestionCollection(savedQuestions: savedQuestions),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}