import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_collection/created_rounds_collection.dart';
import 'package:qmhb/screens/library/rounds/round_collection/saved_rounds_collection.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Rounds"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundEditorPage(
                      type: RoundEditorPageType.ADD,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: DatabaseService().getRoundsByIds(user.roundIds),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingSpinnerHourGlass(),
              );
            }
            if (snapshot.hasError == true) {
              return Center(
                child: Text("Could not load content"),
              );
            }
            final userRounds = snapshot.data
                .where(
                  (RoundModel rd) => rd.userId == user.uid,
                )
                .toList();
            final savedRounds = snapshot.data
                .where(
                  (RoundModel rd) => rd.userId != user.uid,
                )
                .toList();
            return Column(
              children: <Widget>[
                TabBar(
                  tabs: [
                    Tab(child: Text("Created")),
                    Tab(child: Text("Saved")),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      CreatedRoundsCollection(userRounds: userRounds),
                      SavedRoundsCollection(savedRounds: savedRounds),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
