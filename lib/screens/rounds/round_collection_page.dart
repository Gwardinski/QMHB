import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/rounds/round_list_item.dart';
import 'package:qmhb/screens/rounds/round_add_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Rounds"),
        actions: <Widget>[
          FlatButton(
            child: Text('Create New Round'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundAddPage(),
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
              child: Text("Could not load content :("),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length ?? 0,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 16),
            itemBuilder: (BuildContext context, int index) {
              RoundModel roundModel = snapshot.data[index];
              return RoundListItem(
                roundModel: roundModel,
              );
            },
          );
        },
      ),
    );
  }
}
