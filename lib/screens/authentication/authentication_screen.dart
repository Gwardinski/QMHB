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
              Tab(text: 'Register'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SignInScreen(),
            RegisterScreen(),
          ],
        ),
      ),
    );
    ;
  }

  _setTab(i) {
    setState(() {
      activeTab = i;
    });
  }
}
