import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/account/account_page.dart';
import 'package:qmhb/screens/questions/questions_page.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/screens/rounds/rounds_page.dart';
import 'package:qmhb/screens/settings/settings_page.dart';
import 'package:qmhb/shared/widgets/summarys/question_row.dart';
import 'package:qmhb/shared/widgets/summarys/quiz_highlight_row.dart';
import 'package:qmhb/shared/widgets/summarys/round_highlight_row.dart';

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
                QuizHighlightRow(
                  quizIds: user.recentQuizIds,
                  headerTitle: "Your Recent Quizzes",
                  headerButtonText: "See All",
                  headerButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuizzesScreen(),
                      ),
                    );
                  },
                ),
                RoundHighlightRow(
                  roundIds: user.recentRoundIds,
                  headerTitle: "Your Recent Rounds",
                  headerButtonText: "See All",
                  headerButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoundsScreen(),
                      ),
                    );
                  },
                ),
                QuestionRow(
                  questionIds: user.recentQuestionIds,
                  headerTitle: "Your Recent Questions",
                  headerButtonText: "See All",
                  headerButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionsScreen(),
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
