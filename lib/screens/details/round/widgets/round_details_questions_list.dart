import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class RoundDetailsQuestionsList extends StatelessWidget {
  const RoundDetailsQuestionsList({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    QuestionCollectionService questionService = Provider.of<QuestionCollectionService>(context);
    return StreamBuilder(
      stream: questionService.getQuestionsByIds(roundModel.questionIds),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<QuestionModel>> questionSnapshot,
      ) {
        if (questionSnapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinnerHourGlass();
        }
        if (questionSnapshot.hasError) {
          return Container(
            child: Text("An error occured loading this Rounds Questions"),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 120),
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
            );
          },
          itemCount: questionSnapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            QuestionModel question = questionSnapshot.data[index];
            return QuestionListItem(
              questionModel: question,
              canDrag: false,
            );
          },
        );
      },
    );
  }
}
