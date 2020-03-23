import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/account/account_page.dart';
import 'package:qmhb/screens/library/recent_questions_row.dart';
import 'package:qmhb/screens/library/recent_quizzes_row.dart';
import 'package:qmhb/screens/library/recent_rounds_row.dart';
import 'package:qmhb/screens/questions/question_collection_page.dart';
import 'package:qmhb/screens/quizzes/quiz_collection_page.dart';
import 'package:qmhb/screens/rounds/round_collection_page.dart';
import 'package:qmhb/screens/settings/settings_page.dart';
import 'package:qmhb/shared/widgets/highlights/question_highlight_row.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text(user.displayName ?? 'Account'),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AccountPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 8)),
                // RecentQuizzesRow(
                //   headerTitle: "Your Quizzes",
                //   headerButtonText: "See All",
                //   headerButtonFunction: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => QuizCollectionPage(),
                //       ),
                //     );
                //   },
                // ),
                RecentRoundsRow(
                  headerTitle: "Your Rounds",
                  headerButtonText: "See All",
                  headerButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoundCollectionPage(),
                      ),
                    );
                  },
                ),
                RecentQuestionsRow(
                  headerTitle: "Your Questions",
                  headerButtonText: "See All",
                  headerButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionCollectionPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
