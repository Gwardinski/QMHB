import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/list_items/question_list_item.dart';

class SavedQuestionCollection extends StatelessWidget {
  SavedQuestionCollection({
    Key key,
    @required this.savedQuestions,
  }) : super(key: key);

  final savedQuestions;

  @override
  Widget build(BuildContext context) {
    return savedQuestions.length > 0
        ? ListView.builder(
            itemCount: savedQuestions.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              QuestionModel questionModel = savedQuestions[index];
              return QuestionListItem(
                questionModel: questionModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "You haven't saved any questions yet. \n Head to the Explore tab to start searching",
              textAlign: TextAlign.center,
            ),
          );
  }
}
