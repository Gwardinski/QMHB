import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/summarys/summary_tile.dart';

class RoundHighlightRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;
  final List<String> roundIds;

  const RoundHighlightRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
    @required this.roundIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rounds = Provider.of<UserDataStateModel>(context).recentRounds;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: headerTitle,
          headerButtonText: headerButtonText,
          headerButtonFunction: headerButtonFunction,
        ),
        SummaryContentRound(
          rounds: rounds,
        ),
        SummaryRowFooter(),
      ],
    );
  }
}

class SummaryContentRound extends StatelessWidget {
  final List<RoundModel> rounds;
  const SummaryContentRound({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.separated(
        itemCount: rounds?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (10 - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: rounds[index].title,
              line2: "Difficulty",
              line3: "Rounds",
              numberValue: 5,
              starValue: 5,
            ),
          );
        },
      ),
    );
  }
}
