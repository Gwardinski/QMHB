import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/rounds/rounds_library_sidebar.dart';
import 'package:qmhb/shared/widgets/highlights/create_first_question_button.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuestionsLibraryPage extends StatelessWidget {
  final canDrag = getIt<AppSize>().isLarge;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Your Questions"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add_circle),
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
      body: Row(
        children: [
          canDrag ? RoundsLibrarySidebar() : Container(),
          Expanded(
            child: Column(
              children: [
                Toolbar(),
                Expanded(
                  child: StreamBuilder(
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
                        return Center(
                          child: Text("Could not load your questions"),
                        );
                      }
                      return snapshot.data.length > 0
                          ? ListView.separated(
                              separatorBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                );
                              },
                              itemCount: snapshot.data.length ?? 0,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                QuestionModel questionModel = snapshot.data[index];
                                return QuestionListItem(
                                  questionModel: questionModel,
                                  canDrag: canDrag,
                                );
                              },
                            )
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}