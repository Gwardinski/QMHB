import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/highlights/question_column.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_row.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/account_page_button.dart';
import 'package:qmhb/shared/widgets/highlights/round_row.dart';
import 'package:qmhb/shared/widgets/large_signin_prompt.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library'),
        centerTitle: false,
        leading: AppBarBackButton(),
        actions: [
          AccountPageButton(),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: isAuthenticated
          ? SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RecentQuizzes(),
                  RecentRounds(),
                  RecentQuestions(),
                ],
              ),
            )
          : LargeSignInPrompt(),
    );
  }
}

class RecentQuizzes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).quizListener,
      builder: (context, snapshot) {
        return LibraryQuizRow();
      },
    );
  }
}

class RecentRounds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).roundListener,
      builder: (context, snapshot) {
        return LibraryRoundRow();
      },
    );
  }
}

class RecentQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).questionListener,
      builder: (context, snapshot) {
        return LibraryQuestionColumn();
      },
    );
  }
}
