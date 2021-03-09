import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/round_editor_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';

class AddRoundsToQuizPage extends StatefulWidget {
  final QuizModel selectedQuiz;

  AddRoundsToQuizPage({
    @required this.selectedQuiz,
  });

  @override
  _AddRoundsToQuizPageState createState() => _AddRoundsToQuizPageState();
}

class _AddRoundsToQuizPageState extends State<AddRoundsToQuizPage> {
  String _token;
  QuizService _quizService;
  RoundService _roundService;
  RefreshService _refreshService;
  List<RoundModel> _rounds = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _roundService = Provider.of<RoundService>(context, listen: false);
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.roundListener.listen((event) {
      _getRounds();
    });
    _refreshService.roundRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getRounds() async {
    final rounds = await _roundService.getUserRounds(token: _token);
    setState(() {
      _rounds = rounds;
    });
  }

  void _createNewRoundInQuiz(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundEditorPage(
          type: RoundEditorType.ADD,
          quizModel: widget.selectedQuiz,
        ),
      ),
    );
  }

  bool _containsRound(roundModel) {
    return widget.selectedQuiz.rounds.contains(roundModel.id);
  }

  Future<void> _updateQuiz(round) async {
    QuizModel updatedQuiz = widget.selectedQuiz;
    if (_containsRound(round)) {
      updatedQuiz.rounds.remove(round.id);
    } else {
      updatedQuiz.rounds.add(round.id);
    }
    await _quizService.editQuiz(
      quiz: updatedQuiz,
      token: _token,
    );
    _refreshService.quizAndRoundRefresh();
  }

  // TODO - make Quiz collapse when scroll on list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Rounds to Quiz"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.selectedQuiz.title,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "From here you can select the Rounds that you wish to add to this Quiz. You can also de-select a Round to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add New Round",
            onTap: () {
              _createNewRoundInQuiz(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rounds.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AddItemIntoItemButton(
                  title: _rounds[index].title,
                  onTap: () {
                    _updateQuiz(_rounds[index]);
                  },
                  contains: () => _containsRound(_rounds[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
