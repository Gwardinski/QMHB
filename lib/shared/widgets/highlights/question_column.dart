import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/featured_questions_model.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/questions_library_page.dart';
import 'package:qmhb/services/explore_service.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class LibraryQuestionColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuestionModel>>(
      future: Provider.of<QuestionService>(context).getUserQuestions(
        limit: 12,
        sortBy: 'lastUpdated',
        token: Provider.of<UserDataStateModel>(context).token,
      ),
      builder: (context, snapshot) {
        return QuestionColumn(
          title: 'Your Questions',
          onNavigate: () => Provider.of<NavigationService>(context, listen: false).push(
            QuestionsLibraryPage(),
          ),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load your Questions. Please refresh.",
          questionModels: snapshot.data,
        );
      },
    );
  }
}

class FeaturedQuestionsColumn extends StatelessWidget {
  final String featNo;
  final Function onNavigate;

  FeaturedQuestionsColumn({
    Key key,
    @required this.featNo,
    @required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FeaturedQuestions>(
      future: Provider.of<ExploreService>(context).getFeaturedQuestions(
        token: Provider.of<UserDataStateModel>(context).token,
        featNo: featNo,
      ),
      builder: (context, snapshot) {
        return QuestionColumn(
          title: snapshot.data?.title ?? 'Featured Questions',
          description: snapshot.data?.description ?? 'Featured Questions',
          onNavigate: () => onNavigate(data: snapshot.data),
          isLoading: snapshot.connectionState == ConnectionState.waiting,
          hasError: snapshot.hasError,
          errorMessage: "Could not load featured Questions. Please refresh.",
          questionModels: snapshot.data?.questionModels,
        );
      },
    );
  }
}

class QuestionColumn extends StatelessWidget {
  final String title;
  final String description;
  final Function onNavigate;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<QuestionModel> questionModels;

  const QuestionColumn({
    Key key,
    @required this.title,
    this.description,
    @required this.onNavigate,
    @required this.isLoading,
    @required this.hasError,
    @required this.errorMessage,
    @required this.questionModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: title,
          headerDescription: description,
          headerTitleButtonFunction: onNavigate,
          primaryHeaderButtonText: 'View All',
          primaryHeaderButtonFunction: onNavigate,
        ),
        Container(
          child: isLoading
              ? LoadingSpinnerHourGlass()
              : hasError
                  ? ErrorMessage(message: errorMessage)
                  : Column(
                      children: questionModels
                          .map((q) => QuestionListItemWithAction(
                                question: q,
                              ))
                          .toList(),
                    ),
        ),
        SummaryRowFooter(),
      ],
    );
  }
}
