import 'package:flutter/material.dart';
import 'package:qmhb/pages/authentication/register_page.dart';
import 'package:qmhb/pages/authentication/sign_in_page.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          title: Text(activeTab == 0 ? "Sign In" : "Register"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 400,
                child: TabBar(
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
              Container(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Text(
                  (activeTab == 0 ? "Sign in to view " : "Create an account to begin creating ") +
                      "your library.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SignInPage(),
                    RegisterPage(),
                  ],
                ),
              ),
            ],
          ),
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
