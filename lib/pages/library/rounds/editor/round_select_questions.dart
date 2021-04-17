import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/editor/question_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class RoundSelectQuestions extends StatefulWidget {
  final RoundModel round;
  final Function onUpdateQuestions;

  RoundSelectQuestions({
    @required this.round,
    @required this.onUpdateQuestions,
  });

  @override
  _RoundSelectQuestionsState createState() => _RoundSelectQuestionsState();
}

class _RoundSelectQuestionsState extends State<RoundSelectQuestions>
    with AutomaticKeepAliveClientMixin {
  String _token;
  QuestionService _questionService;
  RefreshService _refreshService;
  List<QuestionModel> _questions = [];
  StreamSubscription _subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _questionService = Provider.of<QuestionService>(context, listen: false);
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

  void _createNewQuestionInRound() {
    Provider.of<NavigationService>(context, listen: false).push(
      QuestionEditorPage(
        parentRound: widget.round,
      ),
    );
  }

  bool _containsQuestion(QuestionModel question) {
    return widget.round.questions.contains(question.id);
  }

  Future<void> _updateRound(QuestionModel question) async {
    RoundModel updatedRound = widget.round;
    if (_containsQuestion(question)) {
      updatedRound.questions.remove(question.id);
      updatedRound.questionModels.remove(question);
    } else {
      updatedRound.questions.add(question.id);
      updatedRound.questionModels.add(question);
    }
    widget.onUpdateQuestions(updatedRound);
  }

  Widget build(BuildContext context) {
    super.build(context);
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Column(
      children: [
        Toolbar(
          onUpdateSearchString: (val) => print(val),
          primaryAction: _createNewQuestionInRound,
          primaryText: isLandscape ? "Create New Round" : "New",
        ),
        Expanded(
          child: _questions.length > 0
              ? ListView.builder(
                  itemCount: _questions.length ?? 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return QuestionListItemWithSelect(
                      question: _questions[index],
                      onTap: () => _updateRound(_questions[index]),
                      containsItem: () => _containsQuestion(_questions[index]),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text("You have not created or saved any Questions yet"),
                  ),
                ),
        ),
      ],
    );
  }
}
