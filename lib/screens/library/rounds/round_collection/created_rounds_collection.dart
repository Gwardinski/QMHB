import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/highlights/no_quiz_or_round_widget.dart';
import 'package:qmhb/shared/widgets/round_list_item.dart';

class CreatedRoundsCollection extends StatelessWidget {
  CreatedRoundsCollection({
    Key key,
    @required this.userRounds,
  }) : super(key: key);

  final userRounds;

  @override
  Widget build(BuildContext context) {
    return userRounds.length > 0
        ? ListView.builder(
            itemCount: userRounds.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              RoundModel roundModel = userRounds[index];
              return RoundListItem(
                roundModel: roundModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.only(top: 16),
            child: NoQuizOrRoundWidget(type: NoQuizOrRoundWidgetType.ROUND),
          );
  }
}
