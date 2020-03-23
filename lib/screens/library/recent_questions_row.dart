import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/highlights/question_highlight_row.dart';

class RecentQuestionsRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;

  const RecentQuestionsRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<UserDataStateModel>(context).recentQuestions;
    return QuestionHighlightRow(
      headerTitle: headerTitle,
      headerButtonText: headerButtonText,
      headerButtonFunction: headerButtonFunction,
      questions: questions,
    );
  }
}
