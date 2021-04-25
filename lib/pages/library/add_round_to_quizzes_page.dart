import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_text.dart';
import 'package:qmhb/pages/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class AddRoundToQuizzesPage extends StatefulWidget {
  final RoundModel selectedRound;

  AddRoundToQuizzesPage({
    @required this.selectedRound,
  });

  @override
  _AddRoundToQuizzesPageState createState() => _AddRoundToQuizzesPageState();
}

class _AddRoundToQuizzesPageState extends State<AddRoundToQuizzesPage> {
  String _token;
  QuizService _quizService;
  RefreshService _refreshService;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
  }

  void _createNewQuizwithRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizCreateDialog(
          initialRound: widget.selectedRound,
        );
      },
    );
  }

  bool _containsRound(quiz) {
    return quiz.rounds.contains(widget.selectedRound.id);
  }

  Future<void> _updateQuiz(quiz) async {
    if (_containsRound(quiz)) {
      quiz.rounds.remove(widget.selectedRound.id);
    } else {
      quiz.rounds.add(widget.selectedRound.id);
    }
    await _quizService.editQuiz(
      quiz: quiz,
      token: _token,
    );
    _refreshService.quizAndRoundRefresh();
  }

  // TODO - make header text collapse when scroll on list
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(isLandscape ? "Add Round to Quizzes" : "Add to..."),
        actions: [
          AppBarButton(
            title: "New",
            leftIcon: Icons.add,
            onTap: _createNewQuizwithRound,
          ),
        ],
      ),
      body: Stack(
        children: [
          DetailsHeaderBannerImage(
            imageUrl: widget.selectedRound.imageUrl,
          ),
          Column(
            children: [
              DetailsHeaderBannerText(
                line1: '"${widget.selectedRound.title}"',
                line2: "Select the Quizzes that this Round should be added to.",
                line3:
                    "Changes will be saved automatically.\nAny Quizzes you have published will not appear here. Published Quizzes cannot be edited.",
              ),
              StreamBuilder<bool>(
                stream: _refreshService.quizListener,
                builder: (context, s) {
                  return FutureBuilder<List<QuizModel>>(
                    future: _quizService.getUserQuizzes(
                      token: Provider.of<UserDataStateModel>(context, listen: false).token,
                    ),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Toolbar(
                            onUpdateSearchString: (val) {
                              print(val);
                            },
                            onUpdateFilter: () {},
                            onUpdateSort: () {},
                            results: snapshot.data?.length?.toString() ?? 'loading',
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length ?? 0,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return QuizListItemWithSelect(
                                  quiz: snapshot.data[index],
                                  containsItem: () => _containsRound(snapshot.data[index]),
                                  onTap: () {
                                    _updateQuiz(snapshot.data[index]);
                                  },
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
            ],
          ),
        ],
      ),
    );
  }
}
