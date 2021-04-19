import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/highlights/question_column.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_row.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/account_page_button.dart';
import 'package:qmhb/shared/widgets/highlights/round_row.dart';
import 'package:qmhb/shared/widgets/large_signin_prompt.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';

class LibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library'),
        centerTitle: false,
        actions: [
          AccountPageButton(),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: PageWrapper(
        child: isAuthenticated
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
      ),
    );
  }
}

class RecentQuizzes extends StatelessWidget {
  const RecentQuizzes({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).quizListener,
      builder: (context, snapshot) {
        return QuizRow(
          future: Provider.of<QuizService>(context).getUserQuizzes(
            limit: 8,
            orderBy: 'lastUpdated',
            token: Provider.of<UserDataStateModel>(context).token,
          ),
        );
      },
    );
  }
}

class RecentRounds extends StatelessWidget {
  const RecentRounds({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).roundListener,
      builder: (context, snapshot) {
        return RoundRow(
          future: Provider.of<RoundService>(context).getUserRounds(
            limit: 8,
            orderBy: 'lastUpdated',
            token: Provider.of<UserDataStateModel>(context).token,
          ),
        );
      },
    );
  }
}

class RecentQuestions extends StatelessWidget {
  const RecentQuestions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context).questionListener,
      builder: (context, snapshot) {
        return QuestionColumn(
          future: Provider.of<QuestionService>(context).getUserQuestions(
            limit: 8,
            orderBy: 'lastUpdated',
            token: Provider.of<UserDataStateModel>(context).token,
          ),
        );
      },
    );
  }
}
