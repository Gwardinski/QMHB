import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/no_collection.dart';
import 'package:qmhb/shared/widgets/list_items/list_item_column.dart';
import 'package:qmhb/shared/widgets/list_items/list_item_grid.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
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
            return Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 600,
                    child: TabBar(
                      labelStyle: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                      labelColor: Theme.of(context).accentColor,
                      indicatorColor: Theme.of(context).accentColor,
                      tabs: [
                        Tab(child: Text("Created")),
                        Tab(child: Text("Saved")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        userRounds.length > 0
                            ? RoundCollection(rounds: userRounds)
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: NoCollection(type: NoCollectionType.ROUND),
                              ),
                        savedRounds.length > 0
                            ? RoundCollection(rounds: savedRounds)
                            : Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "You haven't saved any rounds yet. \n Head to the Explore tab to start searching",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class RoundCollection extends StatelessWidget {
  const RoundCollection({
    @required this.rounds,
  });

  final rounds;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 800
        ? ListItemGrid(rounds: rounds)
        : ListItemColumn(rounds: rounds);
  }
}
