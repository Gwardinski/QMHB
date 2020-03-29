import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/authentication_service.dart';
import 'package:qmhb/shared/text_with_title.dart';

class AccountPage extends StatelessWidget {
  final AuthenticationService _authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    final userDataStateModel = Provider.of<UserDataStateModel>(context);
    UserModel user = userDataStateModel.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithTitle(
              title: "Name",
              text: user.displayName,
            ),
            TextWithTitle(
              title: "Email",
              text: user.email,
            ),
            TextWithTitle(
              title: "Questions Created",
              text: user.questionIds.length.toString(),
              highlighText: true,
            ),
            TextWithTitle(
              title: "Rounds Created",
              text: user.roundIds.length.toString(),
              highlighText: true,
            ),
            TextWithTitle(
              title: "Quizzes Created",
              text: user.quizIds.length.toString(),
              highlighText: true,
            ),
          ],
        ),
      ),
    );
  }
}
