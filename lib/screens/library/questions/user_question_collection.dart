import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_items_column.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class UserQuestionsCollection extends StatelessWidget {
  final canDrag;

  UserQuestionsCollection({
    @required this.canDrag,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Column(
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
                print(snapshot.error);
                return Center(
                  child: Text("Could not load content"),
                );
              }
              return snapshot.data.length > 0
                  ? QuestionListItemsColumn(
                      questions: snapshot.data,
                      canDrag: canDrag,
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
    );
  }
}
