import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class RoundDetailsQuestionsList extends StatelessWidget {
  const RoundDetailsQuestionsList({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
        );
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: roundModel.questions.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        QuestionModel questionModel = roundModel.questions[index];
        return QuestionListItem(
          questionModel: questionModel,
          canDrag: false,
        );
      },
    );
  }
}
