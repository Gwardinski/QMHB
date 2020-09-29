import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

import '../../../get_it.dart';

class QuizDetailsWidget extends StatelessWidget {
  const QuizDetailsWidget({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    RoundCollectionService roundCollectionService = Provider.of<RoundCollectionService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuizDetailsHeader(quizModel: quizModel),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Rounds",
        ),
        Expanded(
          child: quizModel.roundIds.length > 0
              ? StreamBuilder(
                  stream: roundCollectionService.getRoundsByIds(quizModel.roundIds),
                  builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> roundSnapshot) {
                    if (roundSnapshot.connectionState == ConnectionState.waiting) {
                      return LoadingSpinnerHourGlass();
                    }
                    if (roundSnapshot.hasError) {
                      return Container(
                        child: Text("err"),
                      );
                    }
                    return ListView.separated(
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
                )
              : Center(child: Text("No Rounds")),
        ),
      ],
    );
  }
}

class QuizDetailsHeader extends StatelessWidget {
  const QuizDetailsHeader({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return getIt<AppSize>().isLarge
        ? DetailsHeaderRow(quizModel: quizModel)
        : DetailsHeaderColumn(quizModel: quizModel);
  }
}

class DetailsHeaderColumn extends StatelessWidget {
  const DetailsHeaderColumn({
    Key key,
    this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            color: Colors.orange,
            margin: EdgeInsets.all(16),
          ),
          Text(
            "Quiz",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            quizModel.title,
            style: TextStyle(
              fontSize: 32,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: getIt<AppSize>().spacingLg)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoColumn(title: "Rounds", value: quizModel.roundIds.length.toString()),
              InfoColumn(title: "Points", value: quizModel.totalPoints.toString()),
              InfoColumn(
                title: "Created",
                value: DateFormat('dd-mm-yyyy').format(quizModel.createdAt),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: quizModel.description != '' ? getIt<AppSize>().spacingLg : 0,
            ),
          ),
          Text(
            quizModel.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsHeaderRow extends StatelessWidget {
  const DetailsHeaderRow({
    Key key,
    this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 160,
                height: 160,
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.only(left: 32),
              ),
              Expanded(
                child: Container(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Quiz",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          quizModel.title,
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InfoColumn(
                              title: "Rounds",
                              value: quizModel.roundIds.length.toString(),
                              padding: true,
                            ),
                            InfoColumn(
                              title: "Points",
                              value: quizModel.totalPoints.toString(),
                              padding: true,
                            ),
                            InfoColumn(
                              title: "Created",
                              value: quizModel.createdAt.toString(),
                              padding: true,
                            ),
                            QuizListItemAction(
                              quizModel: quizModel,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: quizModel.description != '' ? getIt<AppSize>().spacingLg : 0,
            ),
          ),
          Text(
            quizModel.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
