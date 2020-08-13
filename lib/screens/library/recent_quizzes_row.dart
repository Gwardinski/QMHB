import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/quizzes/quiz_collection_page.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RecentQuizzesRow extends StatelessWidget {
  RecentQuizzesRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Quizzes',
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizCollectionPage(),
              ),
            );
          },
        ),
        StreamBuilder(
            stream: Provider.of<QuizCollectionService>(context).getRecentQuizStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("loading");
              }
              if (snapshot.hasError) {
                return Container(
                  child: Text("err"),
                );
              }
              return (snapshot.data.length == 0)
                  ? Row(
                      children: [
                        Expanded(child: CreateNewQuizOrRound(type: CreateNewQuizOrRoundType.QUIZ)),
                      ],
                    )
                  : HighlightRow(
                      quizzes: snapshot.data,
                    );
            }),
        SummaryRowFooter(),
      ],
    );
  }
}
