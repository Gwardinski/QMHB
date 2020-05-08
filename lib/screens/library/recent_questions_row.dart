import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/questions/question_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/question_highlight_row.dart';

class RecentQuestionsRow extends StatelessWidget {
  RecentQuestionsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<RecentActivityStateModel>(context).recentQuestions;
    return QuestionHighlightRow(
      headerTitle: "Questions",
      headerButtonText: "See All",
      questions: questions,
      headerButtonFunction: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionCollectionPage(),
          ),
        );
      },
    );
  }
}
