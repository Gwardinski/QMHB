import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/authentication_service.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    final authenticationService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Account"),
        actions: <Widget>[
          FlatButton(
            child: Text("Sign Out"),
            onPressed: () async {
              await authenticationService.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(getIt<AppSize>().rSpacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoColumn(
                  title: 'Display Name',
                  value: user?.displayName ?? '',
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoColumn(
                  title: 'Email',
                  value: user?.email ?? '',
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoColumn(
                  title: 'Questions',
                  value: user?.questionIds?.length.toString() ?? '',
                ),
                InfoColumn(
                  title: 'Rounds',
                  value: user?.roundIds?.length.toString() ?? '',
                ),
                InfoColumn(
                  title: 'Quizzes',
                  value: user?.quizIds?.length.toString() ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
