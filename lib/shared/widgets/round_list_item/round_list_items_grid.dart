import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:responsive_grid/responsive_grid.dart';

class RoundListItemGrid extends StatelessWidget {
  RoundListItemGrid({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  final List<RoundModel> rounds;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: ResponsiveGridList(
        desiredItemWidth: 400,
        minSpacing: 16,
        children: rounds.map((RoundModel roundModel) {
          return RoundListItem(
            roundModel: roundModel,
          );
        }).toList(),
      ),
    );
  }
}
