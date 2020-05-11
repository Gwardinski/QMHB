import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/no_quiz_or_round_widget.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RecentQuizzesRow extends StatelessWidget {
  RecentQuizzesRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizzes = Provider.of<RecentActivityStateModel>(context).recentQuizzes;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Quizzes',
          headerButtonText: 'See All',
          headerButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizCollectionPage(),
              ),
            );
          },
        ),
        // TODO: New Question Button here
        (quizzes == null || quizzes.length == 0)
            ? NoQuizOrRoundWidget(type: NoQuizOrRoundWidgetType.QUIZ)
            : QuizHighlightRow(
                quizzes: quizzes,
              ),
        SummaryRowFooter(),
      ],
    );
  }
}
