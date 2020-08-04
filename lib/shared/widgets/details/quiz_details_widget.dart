import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/TitleAndDetailsBlock.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/list_items/round_list_item.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuizDetailsWidget extends StatelessWidget {
  const QuizDetailsWidget({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleAndDetailsBlock(
          title: quizModel.title,
          description: quizModel.description,
          item1Title: 'Total Points',
          item1Text: quizModel.totalPoints.toString(),
        ),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Quiz Rounds",
          primaryHeaderButtonText: quizModel.roundIds.length.toString(),
          primaryHeaderButtonFunction: null,
        ),
        Expanded(
          child: FutureBuilder(
            future: databaseService.getRoundsByIds(quizModel.roundIds),
            builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> roundSnapshot) {
              if (roundSnapshot.connectionState == ConnectionState.waiting) {
                return LoadingSpinnerHourGlass();
              }
              return ListView.builder(
                itemCount: roundSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  RoundModel round = roundSnapshot.data[index];
                  return RoundListItem(
                    roundModel: round,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
