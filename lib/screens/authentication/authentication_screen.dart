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
          title: Text(activeTab == 0 ? "Log in" : "Register"),
          bottom: TabBar(
            labelStyle: TextStyle(
              color: Color(0xffFFA630),
            ),
            labelColor: Color(0xffFFA630),
            indicatorColor: Color(0xffFFA630),
            onTap: _setTab,
            tabs: [
              Tab(text: 'Log In'),
              Tab(text: 'Sign up'),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                (activeTab == 0 ? "Log in to view " : "Sign up to create ") +
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
