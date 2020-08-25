import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_items_column.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_items_grid.dart';

class UserRoundsCollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Column(
      children: [
        Container(
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Center(child: Text("Toolbar: Search, Filter, Add, Created / Saved")),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
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
                          CreateNewQuizOrRound(
                            type: CreateNewQuizOrRoundType.ROUND,
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ],
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
        : RoundListItemsColumn(rounds: rounds);
  }
}
