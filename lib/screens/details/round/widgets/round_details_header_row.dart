import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

import '../../../../get_it.dart';

class RoundDetailsHeaderRow extends StatelessWidget {
  const RoundDetailsHeaderRow({
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
                child: (roundModel.imageURL != null)
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
              bottom: roundModel.description != null ? getIt<AppSize>().spacingLg : 0,
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
