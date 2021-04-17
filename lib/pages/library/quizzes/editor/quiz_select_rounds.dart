import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/editor/round_editor_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class QuizSelectRounds extends StatefulWidget {
  final QuizModel quiz;
  final Function onUpdateRounds;

  QuizSelectRounds({
    @required this.quiz,
    @required this.onUpdateRounds,
  });

  @override
  _QuizSelectRoundsState createState() => _QuizSelectRoundsState();
}

class _QuizSelectRoundsState extends State<QuizSelectRounds> with AutomaticKeepAliveClientMixin {
  String _token;
  RoundService _roundService;
  RefreshService _refreshService;
  List<RoundModel> _rounds = [];
  StreamSubscription _subscription;

  @override
  bool get wantKeepAlive => true;

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

  void _createNewRoundInQuiz() {
    Provider.of<NavigationService>(context, listen: false).push(
      RoundEditorPage(
        parentQuiz: widget.quiz,
      ),
    );
  }

  bool _containsRound(RoundModel round) {
    return widget.quiz.rounds.contains(round.id);
  }

  Future<void> _updateQuiz(RoundModel round) async {
    QuizModel updatedQuiz = widget.quiz;
    if (_containsRound(round)) {
      updatedQuiz.rounds.remove(round.id);
      updatedQuiz.roundModels.remove(round);
    } else {
      updatedQuiz.rounds.add(round.id);
      updatedQuiz.roundModels.add(round);
    }
    widget.onUpdateRounds(updatedQuiz);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Column(
      children: [
        Toolbar(
          onUpdateSearchString: (val) => print(val),
          primaryAction: _createNewRoundInQuiz,
          primaryText: isLandscape ? "Create New Round" : "New",
        ),
        Expanded(
          child: _rounds.length > 0
              ? ListView.builder(
                  itemCount: _rounds.length ?? 0,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return RoundListItemWithSelect(
                      round: _rounds[index],
                      onTap: () => _updateQuiz(_rounds[index]),
                      containsItem: () => _containsRound(_rounds[index]),
                    );
                  },
                )
              : Container(
                  child: Center(
                    child: Text("You have not created or saved any Rounds yet"),
                  ),
                ),
        ),
      ],
    );
  }
}
