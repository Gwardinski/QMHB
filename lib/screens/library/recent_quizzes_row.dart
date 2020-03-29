import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_highlight_row.dart';

class RecentQuizzesRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;

  const RecentQuizzesRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizzes = Provider.of<RecentActivityStateModel>(context).recentQuizzes;
    return QuizHighlightRow(
      headerTitle: headerTitle,
      headerButtonText: headerButtonText,
      headerButtonFunction: headerButtonFunction,
      quizzes: quizzes,
    );
  }
}
