import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/question/question_details_dialog.dart';
import 'package:qmhb/pages/library/questions/questions_library_page.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_header.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_item.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class RoundSelectQuestions extends StatelessWidget {
  final RoundModel round;
  final Function onUpdateQuestions;

  RoundSelectQuestions({
    @required this.round,
    @required this.onUpdateQuestions,
  });

  bool _containsQuestion(QuestionModel question) {
    return round.questions.contains(question.id);
  }

  Future<void> _updateRound(QuestionModel question) async {
    RoundModel updatedRound = round;
    if (_containsQuestion(question)) {
      updatedRound.questions.remove(question.id);
      updatedRound.questionModels.removeWhere((r) => r.id == question.id);
    } else {
      updatedRound.questions.add(question.id);
      updatedRound.questionModels.add(question);
    }
    onUpdateQuestions(updatedRound);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<bool>(
            stream: Provider.of<RefreshService>(context, listen: false).questionListener,
            builder: (context, streamSnapshot) {
              return FutureBuilder<List<QuestionModel>>(
                future: Provider.of<QuestionService>(context).getUserQuestions(
                  limit: 8,
                  sortBy: 'lastUpdated',
                  token: Provider.of<UserDataStateModel>(context).token,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorMessage(
                      message: "An error occured loading your Questions",
                    );
                  }
                  return Column(
                    children: [
                      Toolbar(
                        onUpdateSearchString: (s) => print(s),
                        onUpdateFilter: () {},
                        onUpdateSort: () {},
                        results: snapshot.data?.length?.toString() ?? 'loading',
                        hintText: "Search Your Questions",
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (snapshot.data?.length ?? 0) + 1,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return NewQuestionListItem();
                            }
                            return QuestionListItemWithSelect(
                              question: snapshot.data[index - 1],
                              onTap: () => _updateRound(snapshot.data[index - 1]),
                              containsItem: () => _containsQuestion(snapshot.data[index - 1]),
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
        RoundReorderQuestions(
          round: round,
          onReorder: onUpdateQuestions,
        ),
      ],
    );
  }
}

class RoundReorderQuestions extends StatelessWidget {
  final RoundModel round;
  final Function onReorder;

  RoundReorderQuestions({
    @required this.round,
    @required this.onReorder,
  });

  reorder(int oldIndex, int newIndex) {
    var updatedRound = round;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = updatedRound.questions.removeAt(oldIndex);
    final QuestionModel question = updatedRound.questionModels.removeAt(oldIndex);
    updatedRound.questions.insert(newIndex, q);
    updatedRound.questionModels.insert(newIndex, question);
    onReorder(updatedRound);
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
            title: "Selected Questions",
            header1: "Title",
            tooltip1: "Question Title",
            header2: "Pts",
            tooltip2: "No of Points",
            edgePadding: true,
          ),
          Expanded(
            child: round.questionModels.length > 0
                ? ReorderableListView(
                    onReorder: reorder,
                    children: round.questionModels
                        .map(
                          (question) => LibrarySideBarItem(
                            key: Key(question.id.toString()),
                            title: question.question,
                            val1: question.points.toString(),
                            edgePadding: true,
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return QuestionDetailsDialog(
                                    question: question,
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
                      child: Text("You have not selected any Questions yet"),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
