import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quizzes_library_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_grid_item/quiz_grid_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

import '../../../get_it.dart';

class QuizRow extends StatelessWidget {
  final Future future;

  QuizRow({
    Key key,
    @required this.future,
  }) : super(key: key);

  navigate(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      QuizzesLibraryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: FutureBuilder<Object>(
        future: future,
        builder: (context, snapshot) {
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
                height: 140,
                child: FutureBuilder(
                  future: Provider.of<QuizService>(context).getUserQuizzes(
                    limit: 8,
                    orderBy: 'lastUpdated',
                    token: Provider.of<UserDataStateModel>(context).token,
                  ),
                  builder: (BuildContext context, AsyncSnapshot<List<QuizModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingSpinnerHourGlass();
                    }
                    if (snapshot.hasError) {
                      return ErrorMessage(message: "Could not load Quizzes. Please refresh.");
                    }
                    return ListView.separated(
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final paddingSize = getIt<AppSize>().rSpacingMd;
                        EdgeInsets padding = index == 0
                            ? EdgeInsets.only(left: paddingSize)
                            : index == (snapshot.data.length - 1)
                                ? EdgeInsets.only(right: paddingSize)
                                : EdgeInsets.all(0);
                        QuizModel quiz = snapshot.data[index];
                        return Container(
                          padding: padding,
                          child: QuizGridItem(
                            quiz: quiz,
                            action: QuizListItemAction(quiz: quiz),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SummaryRowFooter(),
            ],
          );
        },
      ),
    );
  }
}
