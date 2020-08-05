import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/list_items/list_item_question.dart';

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
              return ListItemQuestion(
                questionModel: questionModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.all(getIt<AppSize>().rSpacingMd),
            child: Text(
              "You haven't saved any questions yet. \n Head to the Explore tab to start searching",
              textAlign: TextAlign.center,
            ),
          );
  }
}
