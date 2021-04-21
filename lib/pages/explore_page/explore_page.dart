import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qmhb/models/featured_questions_model.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/pages/explore_page/feature_items_page.dart';
import 'package:qmhb/pages/explore_page/question_page.dart';
import 'package:qmhb/pages/explore_page/quiz_page.dart';
import 'package:qmhb/pages/explore_page/round_page.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    Key key,
  }) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int activeTab = 0;
  List<QuizModel> initialDataQuiz;
  List<RoundModel> initialDataRound;
  List<QuestionModel> initialDataQuestion;
  String searchStringRound;
  String searchStringQuestion;
  String searchStringQuiz;
  String selectedCategoryRound;
  String selectedCategoryQuestion;
  String selectedCategoryQuiz;
  String sortByRound;
  String sortByQuestion;
  String sortByQuiz;

  _setTab(i) {
    setState(() {
      activeTab = i;
    });
  }

  _onNavigateToQuizzes(FeaturedQuizzes featured) {
    setState(() {
      initialDataQuiz = featured.quizModels;
      searchStringQuiz = featured.searchString;
      sortByQuiz = featured.sortBy;
      selectedCategoryQuiz = featured.selectedCategory;
      activeTab = 1;
    });
  }

  _onNavigateToRounds(FeaturedRounds featured) {
    setState(() {
      initialDataRound = featured.roundModels;
      searchStringRound = featured.searchString;
      sortByRound = featured.sortBy;
      selectedCategoryRound = featured.selectedCategory;
      activeTab = 2;
    });
  }

  _onNavigateToQuestions(FeaturedQuestions featured) {
    setState(() {
      initialDataQuestion = featured.questionModels;
      searchStringQuestion = featured.searchString;
      sortByQuestion = featured.sortBy;
      selectedCategoryQuestion = featured.selectedCategory;
      activeTab = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          title: Text('Explore'),
          leading: AppBarBackButton(),
          actions: [
            Row(
              children: [
                Container(
                  width: 800,
                  child: TabBar(
                    labelStyle: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                    labelColor: Theme.of(context).accentColor,
                    indicatorColor: Theme.of(context).accentColor,
                    onTap: _setTab,
                    tabs: [
                      Tab(text: 'Featured'),
                      Tab(text: 'Quizzes'),
                      Tab(text: 'Rounds'),
                      Tab(text: 'Questions'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: PageWrapper(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    FeaturedItemsPage(
                      onNavigateToQuizzes: _onNavigateToQuizzes,
                      onNavigateToRounds: _onNavigateToRounds,
                      onNavigateToQuestions: _onNavigateToQuestions,
                    ),
                    QuizPage(
                      initialData: initialDataQuiz,
                      searchString: searchStringQuiz,
                      selectedCategory: selectedCategoryQuiz,
                      sortBy: sortByQuiz,
                    ),
                    RoundPage(
                      initialData: initialDataRound,
                      searchString: searchStringRound,
                      selectedCategory: selectedCategoryRound,
                      sortBy: sortByRound,
                    ),
                    QuestionPage(
                      initialData: initialDataQuestion,
                      searchString: searchStringQuestion,
                      selectedCategory: selectedCategoryQuestion,
                      sortBy: sortByQuestion,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
