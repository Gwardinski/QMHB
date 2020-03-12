import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';

class RoundsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationStateModel>(context).user;
    // TODO: get all quizzes from Firebase where their ID contained within user.quizIds;
    return Scaffold(
      appBar: AppBar(
        title: Text("Rounds"),
      ),
      body: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
