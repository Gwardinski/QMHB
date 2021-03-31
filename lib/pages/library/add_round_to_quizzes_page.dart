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
  List<QuizModel> _quizzes = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.quizListener.listen((event) {
      _getQuizzes();
    });
    _refreshService.quizRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getQuizzes() async {
    final quizzes = await _quizService.getUserQuizzes(token: _token);
    setState(() {
      _quizzes = quizzes;
    });
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
    bool useLandscape = MediaQuery.of(context).size.width > 800.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(useLandscape ? "Add Round to Quizzes" : "Add to..."),
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
              Toolbar(
                noOfResults: _quizzes.length,
                onUpdateSearchString: (val) {
                  print(val);
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _quizzes.length ?? 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return QuizListItemWithSelect(
                      quiz: _quizzes[index],
                      containsItem: () => _containsRound(_quizzes[index]),
                      onTap: () {
                        _updateQuiz(_quizzes[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
