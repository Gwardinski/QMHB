import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/screens/library/questions/questions_library_page.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/create_first_question_button.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row_question.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RecentQuestionsRow extends StatelessWidget {
  RecentQuestionsRow({
    Key key,
  }) : super(key: key);

  navigate(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionsLibraryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Questions',
          headerTitleButtonFunction: () {
            navigate(context);
          },
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            navigate(context);
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
                print("err");
                print(snapshot.error.toString());
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