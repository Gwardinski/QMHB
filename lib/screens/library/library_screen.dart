import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/account/account_page.dart';
import 'package:qmhb/screens/settings/settings_page.dart';
import 'package:qmhb/shared/widgets/summarys/question_row.dart';
import 'package:qmhb/shared/widgets/summarys/quiz_row.dart';
import 'package:qmhb/shared/widgets/summarys/round_row.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthenticationStateModel>(context).user;
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
                QuizRow(),
                RoundRow(),
                QuestionRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
