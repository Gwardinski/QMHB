import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/no_question_widget.dart';
import 'package:qmhb/shared/widgets/highlights/question_highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RecentQuestionsRow extends StatelessWidget {
  RecentQuestionsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<RecentActivityStateModel>(context).recentQuestions;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Questions',
          headerButtonText: 'See All',
          headerButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuestionCollectionPage(),
              ),
            );
          },
        ),
        // TODO: New Question Button here
        (questions == null || questions.length == 0)
            ? NoQuestionWidget()
            : QuestionHighlightRow(
                questions: questions,
              ),
        SummaryRowFooter(),
      ],
    );
  }
}
