import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_add_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/no_quiz_or_round_widget.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Rounds"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add),
            label: Text('New'),
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
          if (snapshot.data.length == 0) {
            return Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 16)),
                NoQuizOrRoundWidget(type: NoQuizOrRoundWidgetType.ROUND),
              ],
            );
          }
          // TODO: Link for Adding Questions needed here
          return ListView.builder(
            itemCount: snapshot.data.length ?? 0,
            scrollDirection: Axis.vertical,
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
