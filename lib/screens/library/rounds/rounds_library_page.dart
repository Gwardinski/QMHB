import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/quizzes/quizzes_library_sidebar.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

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
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundEditorPage(
                      type: RoundEditorType.ADD,
                    ),
                  ),
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
                  Expanded(
                    child: StreamBuilder(
                      stream: RoundCollectionService().streamRoundsByIds(
                        ids: user.roundIds,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: LoadingSpinnerHourGlass(),
                          );
                        }
                        if (snapshot.hasError == true) {
                          return ErrorMessage(message: "An error occured loading your Rounds");
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
                                  RoundModel roundModel = snapshot.data[index];
                                  return RoundListItem(
                                    canDrag: canDrag,
                                    roundModel: roundModel,
                                  );
                                },
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
