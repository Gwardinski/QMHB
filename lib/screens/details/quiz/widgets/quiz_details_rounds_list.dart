import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class QuizDetailsRoundsList extends StatelessWidget {
  const QuizDetailsRoundsList({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    RoundCollectionService roundCollectionService = Provider.of<RoundCollectionService>(context);
    return StreamBuilder(
      stream: roundCollectionService.getRoundsByIds(quizModel.roundIds),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<RoundModel>> roundSnapshot,
      ) {
        if (roundSnapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinnerHourGlass();
        }
        if (roundSnapshot.hasError) {
          return Container(
            child: Text("An error occured loading this Quizzes Rounds"),
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
          itemCount: roundSnapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            RoundModel round = roundSnapshot.data[index];
            return RoundListItem(roundModel: round);
          },
        );
      },
    );
  }
}
