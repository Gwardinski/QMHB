import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/screens/authentication/authentication_screen.dart';
import 'package:qmhb/screens/home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = Provider.of<AuthenticationStateModel>(context).isAuthenticated;
    return isAuthenticated != true ? AuthenticationScreen() : HomeScreen();
  }
}
