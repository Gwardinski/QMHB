import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class RoundListItemsColumn extends StatelessWidget {
  RoundListItemsColumn({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final rounds;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      itemCount: rounds.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        RoundModel roundModel = rounds[index];
        return RoundListItem(
          roundModel: roundModel,
        );
      },
    );
  }
}
