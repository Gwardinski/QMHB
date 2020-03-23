import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/questions/question_list_item.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/text_with_title.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
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
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithTitle(
                title: "Title",
                text: roundModel.title,
              ),
              TextWithTitle(
                title: "Description",
                text: roundModel.description,
              ),
              TextWithTitle(
                title: "Total Points",
                text: roundModel.totalPoints.toString(),
              ),
            ],
          ),
        ),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Round Questions",
          headerButtonText: roundModel.questionIds.length.toString(),
          headerButtonFunction: () {},
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
                  return QuestionListItem(questionModel: question);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
