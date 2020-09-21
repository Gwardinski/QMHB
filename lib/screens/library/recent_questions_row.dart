import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/questions/question_collection_page.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row_question.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RecentQuestionsRow extends StatelessWidget {
  RecentQuestionsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Questions',
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuestionCollectionPage(),
              ),
            );
          },
        ),
        StreamBuilder(
            stream: Provider.of<QuestionCollectionService>(context).getRecentQuestionStream(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 128,
                  child: LoadingSpinnerHourGlass(),
                );
              }
              if (snapshot.hasError) {
                return Container(
                  child: Text("err"),
                );
              }
              return (snapshot.data.length == 0)
                  ? CreateFirstQuestionButton()
                  : HighlightRowQuestion(
                      questions: snapshot.data,
                    );
            }),
        SummaryRowFooter(),
      ],
    );
  }
}
