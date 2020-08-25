import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/quizzes/user_quizzes_sidebar.dart';
import 'package:qmhb/screens/library/rounds/user_rounds_collection.dart';
import 'package:qmhb/screens/library/rounds/round_add.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Rounds"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return RoundAdd();
                  },
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            UserQuizzesSidebar(),
            Expanded(
              child: UserRoundsCollection(),
            ),
          ],
        ),
      ),
    );
  }
}
