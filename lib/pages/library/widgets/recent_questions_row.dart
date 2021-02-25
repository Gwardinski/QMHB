import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/pages/library/questions/questions_library_page.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
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
        FutureBuilder(
            future: Provider.of<QuestionService>(context).getUserQuestions(
              limit: 8,
              orderBy: 'TIME',
            ),
            builder: (BuildContext context, AsyncSnapshot<List<QuestionModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 128,
                  child: LoadingSpinnerHourGlass(),
                );
              }
              if (snapshot.hasError) {
                return ErrorMessage(message: "An error occured loading your Questions");
              }
              return (snapshot.data.length == 0)
                  ? CreateFirstQuestionButton()
                  : HighlightRowQuestion(
                      questions: snapshot.data.reversed.toList(),
                    );
            }),
        SummaryRowFooter(),
      ],
    );
  }
}
