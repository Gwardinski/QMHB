import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/widgets/recent_questions_row.dart';
import 'package:qmhb/pages/library/widgets/recent_quizzes_row.dart';
import 'package:qmhb/pages/library/widgets/recent_rounds_row.dart';
import 'package:qmhb/shared/widgets/account_page_button.dart';
import 'package:qmhb/shared/widgets/large_signin_prompt.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build library');
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library'),
        actions: [
          AccountPageButton(),
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
