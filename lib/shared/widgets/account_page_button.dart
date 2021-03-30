import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/pages/authentication/authentication_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';

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
    return AppBarButton(
      title: isAuthenticated ? user?.displayName ?? 'Account' : 'Sign In or Register',
      leftIcon: isAuthenticated ? Icons.account_circle : null,
      onTap: () async {
        Provider.of<NavigationService>(context, listen: false).push(
          AuthenticationPage(),
        );
      },
    );
  }
}
