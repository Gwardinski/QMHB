import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/editor/round_editor_page.dart';
import 'package:qmhb/pages/library/widgets/editor_header.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/grid_item/grid_item.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class QuizSelectRounds extends StatelessWidget {
  final QuizModel quiz;
  final Function onTap;
  final Function containsItem;

  QuizSelectRounds({
    @required this.quiz,
    @required this.onTap,
    @required this.containsItem,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context, listen: false).roundListener,
      builder: (context, streamSnapshot) {
        return FutureBuilder<List<RoundModel>>(
          future: Provider.of<RoundService>(context).getUserRounds(
            limit: 8,
            sortBy: 'lastUpdated',
            token: Provider.of<UserDataStateModel>(context).token,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: "An error occured loading your Rounds",
              );
            }
            return Column(
              children: [
                EditorHeader(
                  title: "Select your Rounds",
                ),
                Toolbar(
                  onUpdateSearchString: (s) => print(s),
                  onUpdateFilter: () {},
                  onUpdateSort: () {},
                  results: snapshot.data?.length?.toString() ?? 'loading',
                  hintText: "Search Your Rounds",
                ),
                isLandscape
                    ? GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data?.length ?? 0) + 1,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 160,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return GridItemNew(
                              title: "New Round",
                              description: "",
                              onTap: () {
                                Provider.of<NavigationService>(context, listen: false).push(
                                  RoundEditorPage(
                                    parentQuiz: quiz,
                                  ),
                                );
                              },
                            );
                          }
                          return RoundGridItemWithSelect(
                            round: snapshot.data[index - 1],
                            onTap: () => onTap(snapshot.data[index - 1]),
                            containsItem: () => containsItem(snapshot.data[index - 1]),
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return RoundListItemWithSelect(
                            round: snapshot.data[index],
                            onTap: () => onTap(snapshot.data[index - 1]),
                            containsItem: () => containsItem(snapshot.data[index - 1]),
                          );
                        },
                      ),
              ],
            );
          },
        );
      },
    );
  }
}

class QuizSelectedRounds extends StatelessWidget {
  final QuizModel quiz;
  final Function onTap;
  final Function containsItem;
  final Function onReorder;

  QuizSelectedRounds({
    @required this.quiz,
    @required this.onTap,
    @required this.containsItem,
    @required this.onReorder,
  });

  reorder(int oldIndex, int newIndex) {
    var updatedQuiz = quiz;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = updatedQuiz.rounds.removeAt(oldIndex);
    final RoundModel round = updatedQuiz.roundModels.removeAt(oldIndex);
    updatedQuiz.rounds.insert(newIndex, q);
    updatedQuiz.roundModels.insert(newIndex, round);
    onReorder(updatedQuiz);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorHeader(
          title: "Selected Rounds",
        ),
        quiz.roundModels?.length == 0
            ? Container(
                height: 112,
                child: Center(
                  child: Text("You have not selected any Rounds."),
                ),
              )
            : Container(
                height: (112 * quiz.roundModels.length).toDouble(),
                child: ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  onReorder: reorder,
                  children: List.generate(
                    quiz.roundModels?.length,
                    (i) => RoundListItemWithSelectAndReorder(
                      key: Key(quiz.roundModels[i].id.toString()),
                      round: quiz.roundModels[i],
                      onTap: () => onTap(quiz.roundModels[i]),
                      containsItem: () => containsItem(quiz.roundModels[i]),
                    ),
                  ),
                ),
              ),
        Padding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}
