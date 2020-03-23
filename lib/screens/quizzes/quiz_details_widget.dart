import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/rounds/round_list_item.dart';
import 'package:qmhb/services/database.dart';
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
      children: [
        Text(quizModel.title),
        Text(quizModel.description ?? 'description'),
        FutureBuilder(
          future: databaseService.getRoundsByIds(quizModel.roundIds),
          builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> roundSnapshot) {
            if (roundSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingSpinnerHourGlass();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: roundSnapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isEven = index.isEven;
                  RoundModel round = roundSnapshot.data[index];
                  return RoundListItem(
                    roundModel: round,
                    isEven: isEven,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
