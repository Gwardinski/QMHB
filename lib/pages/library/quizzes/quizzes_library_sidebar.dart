import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';

class QuizzesLibrarySidebar extends StatefulWidget {
  final RoundModel selectedRound;

  QuizzesLibrarySidebar({
    this.selectedRound,
  });

  @override
  _QuizzesLibrarySidebarState createState() => _QuizzesLibrarySidebarState();
}

class _QuizzesLibrarySidebarState extends State<QuizzesLibrarySidebar> {
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

  void _getQuizzes() async {
    final quizzes = await _quizService.getUserQuizzes(token: _token);
    setState(() {
      _quizzes = quizzes;
    });
  }

  void _openNewQuizForm({RoundModel initialRound}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QuizCreateDialog(
          initialRound: initialRound,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          QuizzesLibrarySidebarNewQuiz(
            onCreateNewQuiz: _openNewQuizForm,
          ),
          QuizzesLibrarySidebarHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: _quizzes.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return QuizzesLibrarySidebarItem(
                  quizModel: _quizzes[index],
                  selectedRound: widget.selectedRound,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuizzesLibrarySidebarNewQuiz extends StatelessWidget {
  final onCreateNewQuiz;

  QuizzesLibrarySidebarNewQuiz({
    this.onCreateNewQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoundModel>(
      onAccept: (question) {
        onCreateNewQuiz(initialRound: question);
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            onCreateNewQuiz();
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "New Quiz",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
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

class QuizzesLibrarySidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Quiz title",
              style: TextStyle(fontSize: 10),
            ),
          ),
          Container(
            width: 32,
            child: Tooltip(
              message: "Number of Rounds",
              child: Text(
                "Rs",
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

class QuizzesLibrarySidebarItem extends StatelessWidget {
  const QuizzesLibrarySidebarItem({
    @required this.quizModel,
    @required this.selectedRound,
  });

  final QuizModel quizModel;
  final RoundModel selectedRound;

  onAcceptNewQuestion(context, question) async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final quizService = Provider.of<QuizService>(context, listen: false);
    final refreshService = Provider.of<RefreshService>(context, listen: false);
    try {
      final updatedQuiz = quizModel;
      updatedQuiz.rounds.add(selectedRound.id);
      await quizService.editQuiz(
        quiz: updatedQuiz,
        token: token,
      );
      refreshService.quizRefresh();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoundModel>(
      onWillAccept: (question) => !quizModel.rounds.contains(question.id),
      onAccept: (question) => onAcceptNewQuestion(context, question),
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizDetailsPage(
                  quizModel: quizModel,
                ),
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
                        quizModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedRound == null
                              ? Theme.of(context).appBarTheme.color
                              : quizModel.rounds.contains(selectedRound?.id)
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
                            quizModel.rounds.length.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Container(
                          width: 16,
                          child: Text(
                            quizModel.totalPoints.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
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
