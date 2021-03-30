import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/pages/authentication/authentication_page.dart';
import 'package:qmhb/services/navigation_service.dart';

class LargeSignInPrompt extends StatelessWidget {
  const LargeSignInPrompt({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: 800),
      child: Center(
        child: TextButton(
          onPressed: () {
            Provider.of<NavigationService>(context, listen: false).push(
              AuthenticationPage(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "Create an account to start your own library of Quizzes, Rounds & Questions, and become the ultimate Quiz Master. \n\n Already got an account ?\nSign in to view your library. \n\n\n\n Click here to get started.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
