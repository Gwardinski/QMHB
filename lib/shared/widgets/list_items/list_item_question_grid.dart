import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/list_items/list_item_question.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ListItemQuestionGrid extends StatelessWidget {
  final List<QuestionModel> questions;

  const ListItemQuestionGrid({
    this.questions,
  });

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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionEditorPage(
                        type: QuestionEditorType.ADD,
                      ),
                    ),
                  );
                },
                text: "Create New",
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(32),
            child: ResponsiveGridList(
                desiredItemWidth: 600,
                minSpacing: 16,
                children: questions.map((QuestionModel questionModel) {
                  return ListItemQuestion(
                    questionModel: questionModel,
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}
