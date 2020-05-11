import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/widgets/highlights/no_question_widget.dart';
import 'package:qmhb/shared/widgets/list_items/question_list_item.dart';

class CreatedQuestionCollection extends StatelessWidget {
  CreatedQuestionCollection({
    Key key,
    @required this.userQuestions,
  }) : super(key: key);

  final userQuestions;

  @override
  Widget build(BuildContext context) {
    return userQuestions.length > 0
        ? ListView.builder(
            itemCount: userQuestions.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              QuestionModel questionModel = userQuestions[index];
              return QuestionListItem(
                questionModel: questionModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: NoQuestionWidget(),
          );
  }
}
