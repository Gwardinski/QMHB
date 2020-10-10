import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

import '../../../../get_it.dart';

class QuizDetailsHeaderRow extends StatelessWidget {
  const QuizDetailsHeaderRow({
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
                child: (quizModel.imageURL != null)
                    ? Image.network(
                        quizModel.imageURL,
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
              bottom: quizModel.description != null ? getIt<AppSize>().spacingLg : 0,
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
