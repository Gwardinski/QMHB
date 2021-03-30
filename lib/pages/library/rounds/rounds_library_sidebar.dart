import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';

class RoundsLibrarySidebar extends StatefulWidget {
  final QuestionModel selectedQuestion;

  RoundsLibrarySidebar({
    @required this.selectedQuestion,
  });

  @override
  _RoundsLibrarySidebarState createState() => _RoundsLibrarySidebarState();
}

class _RoundsLibrarySidebarState extends State<RoundsLibrarySidebar> {
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

  void _getRounds() async {
    final rounds = await _roundService.getUserRounds(token: _token);
    setState(() {
      _rounds = rounds;
    });
  }

  void _openNewRoundForm({QuestionModel initialQuestion}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: initialQuestion,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.black12,
        border: Border(
          right: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          widget.selectedQuestion != null
              ? RoundsLibrarySidebarNewRound(
                  onCreateNewRound: _openNewRoundForm,
                )
              : Container(
                  height: 64,
                ),
          RoundsLibrarySidebarHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _rounds.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return RoundsLibrarySidebarItem(
                  round: _rounds[index],
                  selectedQuestion: widget.selectedQuestion,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoundsLibrarySidebarNewRound extends StatelessWidget {
  final onCreateNewRound;

  RoundsLibrarySidebarNewRound({
    this.onCreateNewRound,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<QuestionModel>(
      onAccept: (question) {
        onCreateNewRound(initialQuestion: question);
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            onCreateNewRound();
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                child: Text(
                  "Add to New Round",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RoundsLibrarySidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Round title",
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            width: 32,
            child: Tooltip(
              message: "Number of Questions",
              child: Text(
                "Qs",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
          Container(
            width: 16,
            child: Tooltip(
              message: "Number of Points",
              child: Text(
                "Pts",
                style: TextStyle(fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundsLibrarySidebarItem extends StatelessWidget {
  const RoundsLibrarySidebarItem({
    @required this.round,
    @required this.selectedQuestion,
  });

  final RoundModel round;
  final QuestionModel selectedQuestion;

  onAcceptNewQuestion(context, question) async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final roundService = Provider.of<RoundService>(context, listen: false);
    final refreshService = Provider.of<RefreshService>(context, listen: false);
    try {
      final updatedRound = round;
      updatedRound.questions.add(selectedQuestion.id);
      await roundService.editRound(
        round: updatedRound,
        token: token,
      );
      refreshService.roundRefresh();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<QuestionModel>(
      onWillAccept: (question) => !round.questions.contains(question.id),
      onAccept: (question) => onAcceptNewQuestion(context, question),
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            Provider.of<NavigationService>(context, listen: false).push(
              RoundDetailsPage(
                initialValue: round,
              ),
            );
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        round.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedQuestion == null
                              ? Theme.of(context).appBarTheme.color
                              : round.questions.contains(selectedQuestion?.id)
                                  ? Colors.grey
                                  : Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 32,
                          child: Text(
                            round.questions.length.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: 16,
                          child: Text(
                            round.totalPoints.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
