import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class RoundHighlightRow extends StatelessWidget {
  final List<RoundModel> rounds;
  const RoundHighlightRow({
    Key key,
    @required this.rounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      child: ListView.separated(
        itemCount: rounds?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (rounds.length - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          RoundModel roundModel = rounds[index];
          return Padding(
            padding: padding,
            child: SummaryTile(
              line1: roundModel.title,
              line2: "Questions",
              line2Value: roundModel.questionIds.length,
              line3: "Total Points",
              line3Value: roundModel.totalPoints,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundDetailsPage(
                      roundModel: roundModel,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
