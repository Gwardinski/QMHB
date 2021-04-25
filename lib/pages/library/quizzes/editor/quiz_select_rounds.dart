import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_dialog.dart';
import 'package:qmhb/pages/library/rounds/editor/round_editor_page.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_header.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_item.dart';
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
  final Function onUpdateRounds;

  QuizSelectRounds({
    @required this.quiz,
    @required this.onUpdateRounds,
  });

  bool _containsRound(RoundModel round) {
    return quiz.rounds.contains(round.id);
  }

  Future<void> _updateQuiz(RoundModel round) async {
    QuizModel updatedQuiz = quiz;
    if (_containsRound(round)) {
      updatedQuiz.rounds.remove(round.id);
      updatedQuiz.roundModels.removeWhere((r) => r.id == round.id);
    } else {
      updatedQuiz.rounds.add(round.id);
      updatedQuiz.roundModels.add(round);
    }
    onUpdateRounds(updatedQuiz);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
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
                      Toolbar(
                        onUpdateSearchString: (s) => print(s),
                        onUpdateFilter: () {},
                        onUpdateSort: () {},
                        results: snapshot.data?.length?.toString() ?? 'loading',
                        hintText: "Search Your Rounds",
                      ),
                      Expanded(
                        child: isLandscape
                            ? GridView.builder(
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
                                    onTap: () => _updateQuiz(snapshot.data[index - 1]),
                                    containsItem: () => _containsRound(snapshot.data[index - 1]),
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: snapshot.data.length ?? 0,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) {
                                  return RoundListItemWithSelect(
                                    round: snapshot.data[index],
                                    onTap: () => _updateQuiz(snapshot.data[index - 1]),
                                    containsItem: () => _containsRound(snapshot.data[index - 1]),
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
        Container(
          width: 1,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.white.withOpacity(0.25),
                width: 1.0,
              ),
            ),
          ),
        ),
        QuizReorderRounds(
          quiz: quiz,
          onReorder: onUpdateRounds,
        ),
      ],
    );
  }
}

class QuizReorderRounds extends StatelessWidget {
  final QuizModel quiz;
  final Function onReorder;

  QuizReorderRounds({
    @required this.quiz,
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
    return Container(
      constraints: BoxConstraints(
        minWidth: 120,
        maxWidth: 280,
      ),
      child: Column(
        children: [
          LibarySidebarHeader(
            title: "Selected Rounds",
            header1: "Title",
            tooltip1: "Round Title",
            header2: "Qs",
            tooltip2: "No of Questions",
            header3: "Pts",
            tooltip3: "Total Points",
            edgePadding: true,
          ),
          Expanded(
            child: quiz.roundModels.length > 0
                ? ReorderableListView(
                    onReorder: reorder,
                    children: quiz.roundModels
                        .map(
                          (round) => LibrarySideBarItem(
                            key: Key(round.id.toString()),
                            title: round.title,
                            val1: round.questions.length.toString(),
                            val2: round.totalPoints.toString(),
                            edgePadding: true,
                            onTap: () {
                              RoundService service =
                                  Provider.of<RoundService>(context, listen: false);
                              String token =
                                  Provider.of<UserDataStateModel>(context, listen: false).token;
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return RoundDetailsDialog(
                                    round: round,
                                    future: service.getRound(
                                      id: round.id,
                                      token: token,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        )
                        .toList(),
                  )
                : Container(
                    child: Center(
                      child: Text("You have not selected any Rounds yet"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
