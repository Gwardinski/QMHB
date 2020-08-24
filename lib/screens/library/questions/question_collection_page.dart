import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/rounds/user_rounds_sidebar.dart';
import 'package:qmhb/screens/library/widgets/question_editor.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_items_column.dart';

class QuestionCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Questions"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuestionEditorPage(
                      type: QuestionEditorType.ADD,
                    ),
                  ),
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
                child: Row(
                  children: [
                    Column(
                      children: [
                        Expanded(child: UserRoundsSidebar()),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          StreamBuilder(
                            stream: QuestionCollectionService().getQuestionsCreatedByUser(
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
                                  ? QuestionListItemsColumn(questions: snapshot.data)
                                  : Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CreateFirstQuestionButton(),
                                        ],
                                      ),
                                    );
                            },
                          ),
                          StreamBuilder(
                            stream: QuestionCollectionService().getQuestionsSavedByUser(
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
                                  ? QuestionListItemsColumn(questions: snapshot.data)
                                  : Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          NoSavedItems(
                                            type: NoSavedItemsType.QUESTION,
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
            ],
          ),
        ),
      ),
    );
  }
}
