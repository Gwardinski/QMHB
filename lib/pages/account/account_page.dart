import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    final userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text("Account"),
        actions: [
          AppBarButton(
            title: "Sign Out",
            onTap: () async {
              userService.signOut();
              Provider.of<NavigationService>(context, listen: false).pop();
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
                  value: user?.totalQuestions.toString() ?? '',
                ),
                InfoColumn(
                  title: 'Rounds',
                  value: user?.totalRounds.toString() ?? '',
                ),
                InfoColumn(
                  title: 'Quizzes',
                  value: user?.totalQuizzes.toString() ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
