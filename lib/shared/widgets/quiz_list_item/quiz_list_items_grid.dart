import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/library/widgets/quiz_add.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:responsive_grid/responsive_grid.dart';

class QuizListItemGrid extends StatelessWidget {
  QuizListItemGrid({
    Key key,
    @required this.quizzes,
  }) : super(key: key);

  final List<QuizModel> quizzes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(52, 32, 0, 0),
              child: ButtonPrimary(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return QuizAdd();
                    },
                  );
                },
                text: "Create New",
                // TODO hide when used in explore tab
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(32),
            child: ResponsiveGridList(
                desiredItemWidth: 400,
                minSpacing: 16,
                children: quizzes.map((QuizModel quizModel) {
                  return QuizListItem(
                    quizModel: quizModel,
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}
