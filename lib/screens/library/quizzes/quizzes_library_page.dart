import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_items_column.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class QuizzesLibraryPage extends StatelessWidget {
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
              icon: Icon(Icons.add_circle),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return QuizCreateDialog();
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Toolbar(),
            Expanded(
              child: StreamBuilder(
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
                    return ErrorMessage(message: "An error occured loading your Quizzes");
                  }
                  return snapshot.data.length > 0
                      ? QuizListItemsColumn(quizzes: snapshot.data)
                      : Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CreateNewQuizOrRound(
                                type: CreateNewQuizOrRoundType.QUIZ,
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
