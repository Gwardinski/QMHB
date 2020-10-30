import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quizzes_library_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

import '../../../get_it.dart';

class RecentQuizzesRow extends StatelessWidget {
  RecentQuizzesRow({
    Key key,
  }) : super(key: key);

  navigate(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizzesLibraryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Quizzes',
          headerTitleButtonFunction: () {
            navigate(context);
          },
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            navigate(context);
          },
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            0,
            getIt<AppSize>().lOnly8,
            0,
            getIt<AppSize>().rSpacingSm,
          ),
          child: StreamBuilder(
              stream: Provider.of<QuizCollectionService>(context).streamQuizzesByIds(
                ids: user.quizIds,
                limit: 8,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<QuizModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 128,
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorMessage(message: "An error occured loading your Quizzes");
                }
                return (snapshot.data.length == 0)
                    ? Row(
                        children: [
                          Expanded(
                            child: CreateNewQuizOrRound(
                              type: CreateNewQuizOrRoundType.QUIZ,
                            ),
                          ),
                        ],
                      )
                    : HighlightRow(
                        quizzes: snapshot.data.reversed.toList(),
                      );
              }),
        ),
        SummaryRowFooter(),
      ],
    );
  }
}
