import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/quiz_grid_item/quiz_grid_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../get_it.dart';

class QuizPage extends StatelessWidget {
  final List<QuizModel> initialData;
  final String searchString;
  final String selectedCategory;
  final String sortBy;

  QuizPage({
    @required this.initialData,
    @required this.searchString,
    @required this.selectedCategory,
    @required this.sortBy,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape = getIt<AppSize>().isLarge ?? false;
    return Column(
      children: [
        Toolbar(
          onUpdateSearchString: (s) => print(s),
          initialValue: searchString,
        ),
        Expanded(
          child: StreamBuilder<bool>(
            stream: Provider.of<RefreshService>(context, listen: false).quizListener,
            builder: (context, streamSnapshot) {
              return FutureBuilder<List<QuizModel>>(
                initialData: initialData,
                future: Provider.of<QuizService>(context).getAllQuizzes(
                  limit: 30,
                  selectedCategory: selectedCategory,
                  searchString: searchString,
                  sortBy: sortBy,
                  token: Provider.of<UserDataStateModel>(context).token,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorMessage(
                      message: "An error occured loading Quizzes",
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
                                  maxCrossAxisExtent: 160,
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
    );
  }
}
