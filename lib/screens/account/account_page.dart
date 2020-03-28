import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/authentication_service.dart';

class AccountPage extends StatelessWidget {
  final AuthenticationService _authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    final userDataStateModel = Provider.of<UserDataStateModel>(context);
    UserModel user = userDataStateModel.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              await _authenticationService.signOut();
              userDataStateModel.removeCurrentUser();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    user?.displayName ?? '',
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    child: Text(user?.email ?? ''),
                  ),
                  Container(
                    child: Text(user?.uid ?? ''),
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
