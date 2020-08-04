import 'package:flutter/material.dart';
import 'package:qmhb/screens/authentication/authentication_screen.dart';

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
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AuthenticationScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "Create an account to start your own library of Quizzes, Rounds & Questions, and become the ultimate Quiz Master. \n\n Already got an account ? Sign in to view your library. \n\n\n\n Click here to get started.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
