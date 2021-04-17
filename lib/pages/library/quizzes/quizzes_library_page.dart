import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';
import 'package:qmhb/shared/widgets/quiz_grid_item/quiz_grid_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuizzesLibraryPage extends StatefulWidget {
  @override
  _QuizzesLibraryPageState createState() => _QuizzesLibraryPageState();
}

class _QuizzesLibraryPageState extends State<QuizzesLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;

  void _createQuiz() async {
    Provider.of<NavigationService>(context, listen: false).push(
      QuizEditorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = getIt<AppSize>().isLarge ?? false;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Your Quizzes"),
        actions: [
          isLandscape
              ? Container()
              : AppBarButton(
                  title: "New",
                  leftIcon: Icons.add,
                  onTap: _createQuiz,
                ),
        ],
      ),
      body: PageWrapper(
        child: Expanded(
          child: Column(
            children: [
              Toolbar(
                onUpdateSearchString: (s) => print(s),
                secondaryText: isLandscape ? "New Quiz" : null,
                secondaryAction: isLandscape ? _createQuiz : null,
              ),
              Expanded(
                child: StreamBuilder<bool>(
                  stream: Provider.of<RefreshService>(context, listen: false).quizListener,
                  builder: (context, streamSnapshot) {
                    return FutureBuilder<List<QuizModel>>(
                      future: Provider.of<QuizService>(context).getUserQuizzes(
                        limit: 8,
                        orderBy: 'lastUpdated',
                        token: Provider.of<UserDataStateModel>(context).token,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessage(
                            message: "An error occured loading your Quizzes",
                          );
                        }
                        return Column(
                          children: [
                            SearchDetails(number: snapshot.data?.length ?? 0),
                            Expanded(
                              child: isLandscape
                                  ? GridView.builder(
                                      itemCount: snapshot.data?.length ?? 0,
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 180,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                      itemBuilder: (BuildContext context, int index) {
                                        return QuizGridItemWithAction(
                                          quiz: snapshot.data[index],
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data.length ?? 0,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context, int index) {
                                        return QuizListItemWithAction(
                                          quiz: snapshot.data[index],
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
