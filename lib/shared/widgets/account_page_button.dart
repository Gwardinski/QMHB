import 'package:flutter/material.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/account/account_page.dart';
import 'package:qmhb/screens/authentication/authentication_screen.dart';

class AccountPageButton extends StatelessWidget {
  const AccountPageButton({
    Key key,
    @required this.isAuthenticated,
    @required this.user,
  }) : super(key: key);

  final bool isAuthenticated;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      label: Text(isAuthenticated ? user?.displayName ?? 'Account' : 'Sign In or Register'),
      icon: Icon(isAuthenticated ? Icons.account_circle : null),
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => isAuthenticated ? AccountPage() : AuthenticationScreen(),
          ),
        );
      },
    );
  }
}
