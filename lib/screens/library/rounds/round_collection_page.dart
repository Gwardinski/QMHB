import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/user_quizzes_sidebar.dart';
import 'package:qmhb/screens/library/rounds/user_rounds_collection.dart';
import 'package:qmhb/screens/library/rounds/round_add_modal.dart';

import '../../../get_it.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final canDrag = getIt<AppSize>().isLarge;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Rounds"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return RoundAddModal();
                  },
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            canDrag ? UserQuizzesSidebar() : Container(),
            Expanded(
              child: UserRoundsCollection(
                canDrag: canDrag,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
