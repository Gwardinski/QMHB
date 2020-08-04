import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/TitleAndDetailsBlock.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/list_items/list_item_question.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundDetailsWidget extends StatelessWidget {
  const RoundDetailsWidget({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndDetailsBlock(
          title: roundModel.title,
          description: roundModel.description,
          item1Title: 'Points',
          item1Text: roundModel.totalPoints.toString(),
        ),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Round Questions",
          primaryHeaderButtonText: roundModel.questionIds.length.toString(),
          primaryHeaderButtonFunction: () {},
        ),
        Expanded(
          child: FutureBuilder(
            future: databaseService.getQuestionsByIds(roundModel.questionIds),
            builder: (BuildContext context, AsyncSnapshot<List<QuestionModel>> questionSnapshot) {
              if (questionSnapshot.connectionState == ConnectionState.waiting) {
                return LoadingSpinnerHourGlass();
              }
              return ListView.builder(
                itemCount: questionSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  QuestionModel question = questionSnapshot.data[index];
                  return ListItemQuestion(questionModel: question);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
