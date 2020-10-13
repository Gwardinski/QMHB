import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
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
    return roundModel.questionIds.length > 1
        ? StreamBuilder(
            stream: questionService.getQuestionsByIds(roundModel.questionIds),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<QuestionModel>> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingSpinnerHourGlass();
              }
              if (snapshot.hasError) {
                return ErrorMessage(message: "An error occured loading this Rounds Questions");
              }
              return snapshot.data.length > 0
                  ? ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                        );
                      },
                      itemCount: snapshot.data.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        QuestionModel questionModel = snapshot.data[index];
                        return QuestionListItem(
                          questionModel: questionModel,
                          roundModel: roundModel,
                          canDrag: false,
                        );
                      },
                    )
                  : NoQuestions();
            },
          )
        : NoQuestions();
  }
}

class NoQuestions extends StatelessWidget {
  const NoQuestions({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("This Round has no Questions"),
        ],
      ),
    );
  }
}
