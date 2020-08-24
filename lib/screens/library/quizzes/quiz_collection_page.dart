import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/screens/library/widgets/quiz_add.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_items_column.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_items_grid.dart';

class QuizCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Quizzes"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return QuizAdd();
                  },
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 600,
                child: TabBar(
                  labelStyle: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                  labelColor: Theme.of(context).accentColor,
                  indicatorColor: Theme.of(context).accentColor,
                  tabs: [
                    Tab(child: Text("Created")),
                    Tab(child: Text("Saved")),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StreamBuilder(
                      stream: QuizCollectionService().getQuizzesCreatedByUser(
                        userId: user.uid,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingSpinnerHourGlass(),
                          );
                        }
                        if (snapshot.hasError == true) {
                          print(snapshot.error);
                          return Center(
                            child: Text("Could not load content"),
                          );
                        }
                        return snapshot.data.length > 0
                            ? QuizCollection(quizzes: snapshot.data)
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CreateNewQuizOrRound(type: CreateNewQuizOrRoundType.ROUND),
                                  ],
                                ),
                              );
                      },
                    ),
                    StreamBuilder(
                      stream: QuizCollectionService().getQuizzesSavedByUser(
                        savedIds: user.questionIds,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingSpinnerHourGlass(),
                          );
                        }
                        if (snapshot.hasError == true) {
                          return Center(
                            child: Text("Could not load content"),
                          );
                        }
                        return snapshot.data.length > 0
                            ? QuizCollection(quizzes: snapshot.data)
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    NoSavedItems(
                                      type: NoSavedItemsType.QUIZ,
                                    ),
                                  ],
                                ),
                              );
                      },
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

class QuizCollection extends StatelessWidget {
  const QuizCollection({
    @required this.quizzes,
  });

  final quizzes;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 800
        ? QuizListItemGrid(quizzes: quizzes)
        : QuizListItemsColumn(quizzes: quizzes);
  }
}
