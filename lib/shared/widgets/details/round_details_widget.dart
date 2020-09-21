import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

import '../../../get_it.dart';

class RoundDetailsWidget extends StatelessWidget {
  const RoundDetailsWidget({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    QuestionCollectionService questionService = Provider.of<QuestionCollectionService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundDetailsHeader(roundModel: roundModel),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Questions",
        ),
        Expanded(
          child: roundModel.questionIds.length > 0
              ? StreamBuilder(
                  stream: questionService.getQuestionsByIds(roundModel.questionIds),
                  builder:
                      (BuildContext context, AsyncSnapshot<List<QuestionModel>> questionSnapshot) {
                    if (questionSnapshot.connectionState == ConnectionState.waiting) {
                      return LoadingSpinnerHourGlass();
                    }
                    if (questionSnapshot.hasError) {
                      return Container(
                        child: Text("err"),
                      );
                    }
                    return ListView.builder(
                      itemCount: questionSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        QuestionModel question = questionSnapshot.data[index];
                        return QuestionListItem(
                          questionModel: question,
                          canDrag: false,
                        );
                      },
                    );
                  },
                )
              : Text("No Questions"),
        ),
      ],
    );
  }
}

class RoundDetailsHeader extends StatelessWidget {
  const RoundDetailsHeader({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return getIt<AppSize>().isLarge
        ? DetailsHeaderRow(roundModel: roundModel)
        : DetailsHeaderColumn(roundModel: roundModel);
  }
}

class DetailsHeaderColumn extends StatelessWidget {
  const DetailsHeaderColumn({
    Key key,
    this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

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
            "Round",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            roundModel.title,
            style: TextStyle(
              fontSize: 32,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: getIt<AppSize>().spacingLg)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoColumn(title: "Questions", value: roundModel.questionIds.length.toString()),
              InfoColumn(title: "Points", value: roundModel.totalPoints.toString()),
              InfoColumn(title: "Created", value: roundModel.createdAt.toString()),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: roundModel.description != '' ? getIt<AppSize>().spacingLg : 0,
            ),
          ),
          Text(
            roundModel.description,
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
    this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

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
                              "Round",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          roundModel.title,
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
                              title: "Questions",
                              value: roundModel.questionIds.length.toString(),
                              padding: true,
                            ),
                            InfoColumn(
                              title: "Points",
                              value: roundModel.totalPoints.toString(),
                              padding: true,
                            ),
                            InfoColumn(
                              title: "Created",
                              value: roundModel.createdAt.toString(),
                              padding: true,
                            ),
                            RoundListItemAction(
                              roundModel: roundModel,
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
              bottom: roundModel.description != '' ? getIt<AppSize>().spacingLg : 0,
            ),
          ),
          Text(
            roundModel.description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
