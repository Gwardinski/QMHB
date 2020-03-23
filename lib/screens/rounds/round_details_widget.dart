import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/questions/question_list_item.dart';
import 'package:qmhb/services/database.dart';
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
      children: [
        Text(roundModel.title),
        Text(roundModel.description ?? 'description'),
        FutureBuilder(
          future: databaseService.getQuestionsByIds(roundModel.questionIds),
          builder: (BuildContext context, AsyncSnapshot<List<QuestionModel>> questionSnapshot) {
            if (questionSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingSpinnerHourGlass();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: questionSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  QuestionModel question = questionSnapshot.data[index];
                  return QuestionListItem(questionModel: question);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
