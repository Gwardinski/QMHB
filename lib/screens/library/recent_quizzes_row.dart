import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/quizzes/quiz_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_highlight_row.dart';

class RecentQuizzesRow extends StatelessWidget {
  RecentQuizzesRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quizzes = Provider.of<RecentActivityStateModel>(context).recentQuizzes;
    return QuizHighlightRow(
      headerTitle: "Quizzes",
      headerButtonText: "See All",
      quizzes: quizzes,
      headerButtonFunction: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizCollectionPage(),
          ),
        );
      },
    );
  }
}
