import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';

class AddQuestionToRoundsPage extends StatefulWidget {
  final QuestionModel selectedQuestion;

  AddQuestionToRoundsPage({
    @required this.selectedQuestion,
  });

  @override
  _AddQuestionToRoundsPageState createState() => _AddQuestionToRoundsPageState();
}

class _AddQuestionToRoundsPageState extends State<AddQuestionToRoundsPage> {
  String _token;
  RoundService _roundService;
  RefreshService _refreshService;
  List<RoundModel> _rounds = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _roundService = Provider.of<RoundService>(context, listen: false);
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

  void createNewRoundwithQuestion(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: widget.selectedQuestion,
        );
      },
    );
  }

  bool _containsQuestion(roundModel) {
    return roundModel.questions.contains(widget.selectedQuestion.id);
  }

  Future<void> _updateRound(roundModel) async {
    if (_containsQuestion(roundModel)) {
      roundModel.questions.remove(widget.selectedQuestion.id);
    } else {
      roundModel.questions.add(widget.selectedQuestion.id);
    }
    await _roundService.editRound(
      round: roundModel,
      token: _token,
    );
    _refreshService.roundAndQuestionRefresh();
  }

  // TODO - make question collapse when scroll on list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to Rounds"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.selectedQuestion.question,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "From here you can select the Rounds that you wish to add this Question to. You can also de-select a Round to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add to New Round",
            onTap: () {
              createNewRoundwithQuestion(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rounds.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AddItemIntoItemButton(
                  onTap: () {
                    _updateRound(_rounds[index]);
                  },
                  contains: () => _containsQuestion(_rounds[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
