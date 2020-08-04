import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_collection/created_quizzes_collection.dart';
import 'package:qmhb/screens/library/quizzes/quiz_collection/saved_quizzes_collection.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuizCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Quizzes"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizEditorPage(
                      type: QuizEditorPageType.ADD,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: DatabaseService().getQuizzesByIds(user.quizIds),
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
            final userQuizzes = snapshot.data
                .where(
                  (QuizModel qz) => qz.userId == user.uid,
                )
                .toList();
            final savedQuizzes = snapshot.data
                .where(
                  (QuizModel qz) => qz.userId != user.uid,
                )
                .toList();
            return Column(
              children: <Widget>[
                TabBar(
                  labelStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  labelColor: Theme.of(context).accentColor,
                  indicatorColor: Theme.of(context).accentColor,
                  tabs: [
                    Tab(child: Text("Created")),
                    Tab(child: Text("Saved")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      CreatedQuizzesCollection(userQuizzes: userQuizzes),
                      SavedQuizzesCollection(savedQuizzes: savedQuizzes),
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
