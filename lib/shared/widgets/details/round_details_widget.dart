import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';
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
    return ListView(
      children: [
        RoundDetailsHeader(roundModel: roundModel),
        Divider(),
        SummaryRowHeader(
          headerTitle: "Questions",
        ),
        roundModel.questionIds.length > 0
            ? StreamBuilder(
                stream: questionService.getQuestionsByIds(roundModel.questionIds),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<QuestionModel>> questionSnapshot,
                ) {
                  if (questionSnapshot.connectionState == ConnectionState.waiting) {
                    return LoadingSpinnerHourGlass();
                  }
                  if (questionSnapshot.hasError) {
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
            : Center(
                child: Text("This Round has no Questions"),
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

class DetailsHeaderColumn extends StatefulWidget {
  const DetailsHeaderColumn({
    Key key,
    this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  _DetailsHeaderColumnState createState() => _DetailsHeaderColumnState();
}

class _DetailsHeaderColumnState extends State<DetailsHeaderColumn> {
  bool isExpanded = false;

  expandImage(bool expand) {
    setState(() {
      isExpanded = expand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (widget.roundModel.imageURL != null && widget.roundModel.imageURL != "")
            ? GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0)
                    expandImage(true);
                  else
                    expandImage(false);
                },
                onTap: () {
                  expandImage(true);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: double.infinity,
                  height: isExpanded ? 300 : 120,
                  margin: EdgeInsets.only(bottom: 32),
                  child: ImageSwitcher(
                    fileImage: null,
                    networkImage: widget.roundModel.imageURL,
                  ),
                ),
              )
            : Container(height: 32),
        Text(
          "Round",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          widget.roundModel.title,
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: getIt<AppSize>().spacingLg)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoColumn(title: "Questions", value: widget.roundModel.questionIds.length.toString()),
            InfoColumn(title: "Points", value: widget.roundModel.totalPoints.toString()),
            InfoColumn(
              title: "Created",
              value: DateFormat('dd-mm-yyyy').format(widget.roundModel.createdAt),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            getIt<AppSize>().spacingLg,
          ),
          child: Text(
            widget.roundModel.description ?? 'no description',
            style: TextStyle(
              fontSize: 16,
              fontStyle: widget.roundModel.description != '' ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
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
                child: (roundModel.imageURL != null && roundModel.imageURL != "")
                    ? Image.network(
                        roundModel.imageURL,
                        fit: BoxFit.cover,
                      )
                    : Container(),
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
