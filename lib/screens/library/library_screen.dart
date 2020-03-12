import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/account/account_page.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/screens/rounds/rounds_page.dart';
import 'package:qmhb/screens/settings/settings_page.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/quiz_summary.dart';
import 'package:qmhb/shared/widgets/round_summary.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthenticationStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Recent Quizzes"),
                      ButtonText(
                        text: "See All",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QuizzesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                  Container(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.only(right: 16),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return QuizSummary();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Recent Rounds"),
                      ButtonText(
                        text: "See All",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RoundsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                  Container(
                    height: 120,
                    child: ListView.separated(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.only(right: 16),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return RoundSummary();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
                    child: Divider(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Recent Questions"),
                      Text(
                        "See all",
                        style: TextStyle(
                          color: Color(0xffFFA630),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                  ),
                  Container(
                    height: 500,
                    child: ListView.separated(
                      itemCount: 10,
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
