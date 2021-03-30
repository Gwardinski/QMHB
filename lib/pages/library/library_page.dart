import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/pages/library/widgets/recent_questions_row.dart';
import 'package:qmhb/pages/library/widgets/recent_quizzes_row.dart';
import 'package:qmhb/pages/library/widgets/recent_rounds_row.dart';
import 'package:qmhb/shared/widgets/account_page_button.dart';
import 'package:qmhb/shared/widgets/large_signin_prompt.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print('build library');
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Library'),
        actions: [
          AccountPageButton(isAuthenticated: isAuthenticated, user: user),
        ],
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.pink,
          child: Center(
            child: Text(counter.toString()),
          ),
        ),
        onTap: () {
          setState(() {
            counter = counter + 1;
          });
        },
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
