import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/question_editor_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class AddQuestionsToRoundPage extends StatefulWidget {
  final RoundModel selectedRound;

  AddQuestionsToRoundPage({
    @required this.selectedRound,
  });

  @override
  _AddQuestionsToRoundPageState createState() => _AddQuestionsToRoundPageState();
}

class _AddQuestionsToRoundPageState extends State<AddQuestionsToRoundPage> {
  String _token;
  RoundService _roundService;
  QuestionService _questionService;
  RefreshService _refreshService;
  List<QuestionModel> _questions = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _questionService = Provider.of<QuestionService>(context, listen: false);
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.questionListener.listen((event) {
      _getQuestions();
    });
    _refreshService.questionRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getQuestions() async {
    final questions = await _questionService.getUserQuestions(token: _token);
    setState(() {
      _questions = questions;
    });
  }

  void _createNewQuestionInRound(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          type: QuestionEditorType.ADD,
          roundModel: widget.selectedRound,
        ),
      ),
    );
  }

  bool _containsQuestion(questionModel) {
    return widget.selectedRound.questions.contains(questionModel.id);
  }

  Future<void> _updateRound(question) async {
    RoundModel updatedRound = widget.selectedRound;
    if (_containsQuestion(question)) {
      updatedRound.questions.remove(question.id);
    } else {
      updatedRound.questions.add(question.id);
    }
    await _roundService.editRound(
      round: updatedRound,
      token: _token,
    );
    _refreshService.roundAndQuestionRefresh();
  }

  // TODO - make Round collapse when scroll on list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Questions to Round"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              widget.selectedRound.title,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "From here you can select the Questions that you wish to add to this Round. You can also de-select a Question to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add New Question",
            onTap: () {
              _createNewQuestionInRound(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AddItemIntoItemButton(
                  title: _questions[index].question,
                  onTap: () {
                    _updateRound(_questions[index]);
                  },
                  contains: () => _containsQuestion(_questions[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
