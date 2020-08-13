import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/screens/library/widgets/round_editor.dart';
import 'package:qmhb/services/round_collection_service.dart';
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
                      type: RoundEditorType.ADD,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Center(
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
                    StreamBuilder(
                      stream: RoundCollectionService().getRoundsCreatedByUser(
                        userId: user.uid,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingSpinnerHourGlass(),
                          );
                        }
                        if (snapshot.hasError == true) {
                          print(snapshot.error);
                          return Center(
                            child: Text("Could not load content"),
                          );
                        }
                        return snapshot.data.length > 0
                            ? RoundCollection(rounds: snapshot.data)
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CreateNewQuizOrRound(type: CreateNewQuizOrRoundType.ROUND),
                                  ],
                                ),
                              );
                      },
                    ),
                    StreamBuilder(
                      stream: RoundCollectionService().getRoundsSavedByUser(
                        savedIds: user.questionIds,
                      ),
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
                        return snapshot.data.length > 0
                            ? RoundCollection(rounds: snapshot.data)
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    NoSavedItems(
                                      type: NoSavedItemsType.ROUND,
                                    ),
                                  ],
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        ? RoundListItemGrid(rounds: rounds)
        : RoundListItemColumn(rounds: rounds);
  }
}
