import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quizzes_library_page.dart';
import 'package:qmhb/services/explore_service.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_grid_item/quiz_grid_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

import '../../../get_it.dart';

class LibraryQuizRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizModel>>(
      future: Provider.of<QuizService>(context).getUserQuizzes(
        limit: 8,
        sortBy: 'lastUpdated',
        token: Provider.of<UserDataStateModel>(context).token,
      ),
      builder: (context, snapshot) {
        return QuizRow(
          title: 'Your Quizzes',
          description: 'Recently updated',
          onNavigate: () => Provider.of<NavigationService>(context, listen: false).push(
            QuizzesLibraryPage(),
          ),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load your Quizzes. Please refresh.",
          quizModels: snapshot.data,
        );
      },
    );
  }
}

class FeaturedQuizRow extends StatelessWidget {
  final String featNo;
  final Function onNavigate;

  FeaturedQuizRow({
    Key key,
    @required this.featNo,
    @required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FeaturedQuizzes>(
      future: Provider.of<ExploreService>(context).getFeaturedQuizzes(
        token: Provider.of<UserDataStateModel>(context).token,
        featNo: featNo,
      ),
      builder: (context, snapshot) {
        return QuizRow(
          title: snapshot.data?.title ?? 'Quizzes',
          description: snapshot.data?.description ?? 'Featured Quizzes',
          onNavigate: () => onNavigate(data: snapshot.data),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load featured Quizzes. Please refresh.",
          quizModels: snapshot.data?.quizModels,
        );
      },
    );
  }
}

class QuizRow extends StatelessWidget {
  final String title;
  final String description;
  final Function onNavigate;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<QuizModel> quizModels;

  const QuizRow({
    Key key,
    @required this.title,
    @required this.description,
    @required this.onNavigate,
    @required this.isLoading,
    @required this.hasError,
    @required this.errorMessage,
    @required this.quizModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Column(
        children: [
          SummaryRowHeader(
            headerTitle: title,
            headerTitleButtonFunction: onNavigate,
            primaryHeaderButtonText: 'See All',
            primaryHeaderButtonFunction: onNavigate,
          ),
          Container(
            height: 140,
            child: isLoading
                ? LoadingSpinnerHourGlass()
                : hasError
                    ? ErrorMessage(message: errorMessage)
                    : ListView.separated(
                        itemCount: quizModels.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (BuildContext context, int index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final paddingSize = getIt<AppSize>().rSpacingMd;
                          EdgeInsets padding = index == 0
                              ? EdgeInsets.only(left: paddingSize)
                              : index == (quizModels.length - 1)
                                  ? EdgeInsets.only(right: paddingSize)
                                  : EdgeInsets.all(0);
                          QuizModel quiz = quizModels[index];
                          return Container(
                            padding: padding,
                            child: QuizGridItem(
                              quiz: quiz,
                              action: QuizListItemAction(quiz: quiz),
                            ),
                          );
                        },
                      ),
          ),
          SummaryRowFooter(),
        ],
      ),
    );
  }
}
