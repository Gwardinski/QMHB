import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/rounds/round_list_item.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/text_with_title.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
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
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithTitle(
                title: "Title",
                text: quizModel.title,
              ),
              TextWithTitle(
                title: "Description",
                text: quizModel.description,
              ),
              TextWithTitle(
                title: "Total Points",
                text: quizModel.totalPoints.toString(),
              ),
            ],
          ),
        ),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Quiz Rounds",
          headerButtonText: quizModel.roundIds.length.toString(),
          headerButtonFunction: () {},
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
