import 'package:flutter/material.dart';
import 'package:qmhb/screens/authentication/register_screen.dart';
import 'package:qmhb/screens/authentication/sign_in_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  AuthenticationScreen({Key key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(activeTab == 0 ? "Sign In" : "Register"),
          bottom: TabBar(
            labelStyle: TextStyle(
              color: Theme.of(context).accentColor,
            ),
            labelColor: Theme.of(context).accentColor,
            indicatorColor: Theme.of(context).accentColor,
            onTap: _setTab,
            tabs: [
              Tab(text: 'Sign In'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
              child: Text(
                (activeTab == 0 ? "Sign in to view " : "Create an account to begin creating ") +
                    "your library of Quizzes, Rounds and Questions",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SignInScreen(),
                  RegisterScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setTab(i) {
    setState(() {
      activeTab = i;
    });
  }
}
