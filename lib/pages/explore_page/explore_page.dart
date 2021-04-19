import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_row.dart';
import 'package:qmhb/shared/widgets/highlights/round_row.dart';
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
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          QuizRow(
                            future: Provider.of<QuizService>(context).getUserQuizzes(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          QuizRow(
                            future: Provider.of<QuizService>(context).getUserQuizzes(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          QuizRow(
                            future: Provider.of<QuizService>(context).getUserQuizzes(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          RoundRow(
                            future: Provider.of<RoundService>(context).getUserRounds(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          RoundRow(
                            future: Provider.of<RoundService>(context).getUserRounds(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          RoundRow(
                            future: Provider.of<RoundService>(context).getUserRounds(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                          RoundRow(
                            future: Provider.of<RoundService>(context).getUserRounds(
                              limit: 8,
                              orderBy: 'lastUpdated',
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                          ),
                        ],
                      ),
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
