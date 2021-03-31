import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/pages/account/account_page.dart';
import 'package:qmhb/pages/authentication/authentication_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';

class AccountPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<UserDataStateModel>(context).isAuthenticated;
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return AppBarButton(
      title: isAuthenticated ? user?.displayName ?? 'Account' : 'Sign In or Register',
      leftIcon: isAuthenticated ? Icons.account_circle : null,
      onTap: () async {
        Provider.of<NavigationService>(context, listen: false).push(
          isAuthenticated ? AccountPage() : AuthenticationPage(),
        );
      },
    );
  }
}
