import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/questions/question_list_item.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class QuestionHighlightRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;
  final List<QuestionModel> questions;

  const QuestionHighlightRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
    @required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      height: 400,
      child: ListView.builder(
        itemCount: questions?.length ?? 0,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return QuestionListItem(
            questionModel: questions[index],
          );
        },
      ),
    );
  }
}
