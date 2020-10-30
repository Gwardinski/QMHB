import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
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
      stream: roundCollectionService.streamRoundsByIds(
        ids: quizModel.roundIds,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<RoundModel>> snapshot,
      ) {
        if (!snapshot.hasData) {
          return LoadingSpinnerHourGlass();
        }
        if (snapshot.hasError) {
          return ErrorMessage(message: "An error occured loading this Quizzes Rounds");
        }
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
            );
          },
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot.data.length ?? 0,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            RoundModel roundModel = snapshot.data[index];
            return RoundListItem(
              roundModel: roundModel,
              canDrag: false,
            );
          },
        );
      },
    );
  }
}
