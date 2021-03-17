import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';

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
    final quiz = await _quizService.getUserQuizzes(token: _token);
    setState(() {
      _quizzes = quiz;
    });
  }

  void createNewQuizwithRound(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizCreateDialog(
          initialRound: widget.selectedRound,
        );
      },
    );
  }

  bool _containsRound(quizModel) {
    return quizModel.rounds.contains(widget.selectedRound.id);
  }

  Future<void> _updateQuiz(quizModel) async {
    if (_containsRound(quizModel)) {
      quizModel.rounds.remove(widget.selectedRound.id);
    } else {
      quizModel.rounds.add(widget.selectedRound.id);
    }
    await _quizService.editQuiz(
      quiz: quizModel,
      token: _token,
    );
    _refreshService.quizAndRoundRefresh();
  }

  // TODO - make round collapse when scroll on list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Round to Quizzes"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(widget.selectedRound.title),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "From here you can select the Quizzes that you wish to add this Round to. You can also de-select a Quiz to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add to New Quiz",
            onTap: () {
              createNewQuizwithRound(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _quizzes.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AddItemIntoItemButton(
                  onTap: () {
                    _updateQuiz(_quizzes[index]);
                  },
                  contains: () => _containsRound(_quizzes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
