import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/round_list_item.dart';

class SavedRoundsCollection extends StatelessWidget {
  SavedRoundsCollection({
    Key key,
    @required this.savedRounds,
  }) : super(key: key);

  final savedRounds;

  @override
  Widget build(BuildContext context) {
    return savedRounds.length > 0
        ? ListView.builder(
            itemCount: savedRounds.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              RoundModel roundModel = savedRounds[index];
              return RoundListItem(
                roundModel: roundModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "You haven't saved any rounds yet. \n Head to the Explore tab to start searching",
              textAlign: TextAlign.center,
            ),
          );
  }
}
