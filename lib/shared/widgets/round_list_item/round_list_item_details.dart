import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_line1.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_line2.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_line3.dart';

class RoundListItemDetails extends StatelessWidget {
  const RoundListItemDetails({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RoundListItemLine1(
            text: roundModel.title,
          ),
          RoundListItemLine2(
            description: roundModel.description,
          ),
          RoundListItemLine3(
            points: roundModel.totalPoints.toString(),
            questions: roundModel.questionIds.length.toString() ?? 'awd',
          ),
        ],
      ),
    );
  }
}
