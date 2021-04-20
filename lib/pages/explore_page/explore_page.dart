import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/pages/explore_page/feature_items_page.dart';
import 'package:qmhb/pages/explore_page/quiz_page.dart';
import 'package:qmhb/pages/explore_page/round_page.dart';
import 'package:qmhb/services/navigation_service.dart';
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

  _setTab(i) {
    setState(() {
      activeTab = i;
    });
  }

  _onNavigateToQuizzes(FeaturedQuizzes featured) {
    Provider.of<NavigationService>(context, listen: false).push(
      QuizPage(
        initialData: featured.quizModels,
        searchString: featured.searchString,
        selectedCategory: featured.selectedCategory,
        sortBy: featured.sortBy,
      ),
    );
  }

  _onNavigateToRounds(FeaturedRounds featured) {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundPage(
        initialData: featured.roundModels,
        searchString: featured.searchString,
        selectedCategory: featured.selectedCategory,
        sortBy: featured.sortBy,
      ),
    );
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
                      onNavigateToRounds: _onNavigateToRounds,
                      onNavigateToQuizzes: _onNavigateToQuizzes,
                    ),
                    Container(
                      color: Colors.pink,
                    ),
                    Container(
                      color: Colors.green,
                    ),
                    Container(
                      color: Colors.yellow,
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
