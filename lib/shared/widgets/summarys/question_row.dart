import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';

class QuestionRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;
  final List<String> questionIds;

  const QuestionRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
    @required this.questionIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<UserDataStateModel>(context).recentQuestions;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: headerTitle,
          headerButtonText: headerButtonText,
          headerButtonFunction: headerButtonFunction,
        ),
        SummaryQuestionRowContent(
          questions: questions,
        ),
        SummaryRowFooter(),
      ],
    );
  }
}

class SummaryQuestionRowContent extends StatelessWidget {
  final List<QuestionModel> questions;
  const SummaryQuestionRowContent({
    Key key,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.separated(
        itemCount: questions?.length ?? 0,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (10 - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          return Padding(
            padding: padding,
            // child: QuestionSummary(
            //   questionModel: questions[index],
            // ),
          );
        },
      ),
    );
  }
}
