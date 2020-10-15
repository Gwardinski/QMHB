import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/widgets/recent_questions_row.dart';
import 'package:qmhb/screens/library/widgets/recent_quizzes_row.dart';
import 'package:qmhb/screens/library/widgets/recent_rounds_row.dart';
import 'package:qmhb/shared/widgets/account_page_button.dart';
import 'package:qmhb/shared/widgets/large_signin_prompt.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library'),
        actions: <Widget>[
          AccountPageButton(isAuthenticated: isAuthenticated, user: user),
          // SettingsPageButton(),
        ],
      ),
      body: isAuthenticated
          ? SingleChildScrollView(
              child: Column(
                children: [
                  RecentQuizzesRow(),
                  RecentRoundsRow(),
                  RecentQuestionsRow(),
                ],
              ),
            )
          : LargeSignInPrompt(),
    );
  }
}
