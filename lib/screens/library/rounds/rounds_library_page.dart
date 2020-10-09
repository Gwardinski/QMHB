import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quizzes_library_sidebar.dart';
import 'package:qmhb/screens/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_items_column.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class RoundCollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final canDrag = getIt<AppSize>().isLarge;
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Your Rounds"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text('New'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return RoundCreateDialog();
                  },
                );
              },
            ),
          ],
        ),
        body: Row(
          children: [
            canDrag ? QuizzesLibrarySidebar() : Container(),
            Expanded(
              child: Column(
                children: [
                  Toolbar(),
                  Expanded(
                    child: StreamBuilder(
                      stream: RoundCollectionService().getRoundsCreatedByUser(
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
                            ? RoundListItemsColumn(
                                rounds: snapshot.data,
                                canDrag: canDrag,
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CreateNewQuizOrRound(
                                      type: CreateNewQuizOrRoundType.ROUND,
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
          ],
        ),
      ),
    );
  }
}
