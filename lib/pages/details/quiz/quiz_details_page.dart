import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_list_empty.dart';
import 'package:qmhb/pages/details/widgets/details_header.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizDetailsPage extends StatefulWidget {
  const QuizDetailsPage({
    Key key,
    @required this.initialValue,
  }) : super(key: key);

  final QuizModel initialValue;

  @override
  _QuizDetailsPageState createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  QuizService _quizService;
  RefreshService _refreshService;
  QuizModel _quiz;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _quiz = widget.initialValue;
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.quizListener.listen((event) {
      _getQuiz();
    });
    _refreshService.quizRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getQuiz() async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final quiz = await _quizService.getQuiz(token: token, id: _quiz.id);
    setState(() {
      _quiz = quiz;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quiz Details"),
        actions: [
          QuizListItemAction(
            quiz: _quiz,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DetailsHeader(
              type: "Quiz",
              title: _quiz.title,
              description: _quiz.description,
              info1Title: "Rounds",
              info2Title: "Points",
              info3Title: "Created",
              info1Value: _quiz.rounds.length.toString(),
              info2Value: _quiz.totalPoints.toString(),
              info3Value: DateFormat('d-MM-yy').format(_quiz.createdAt),
              imageUrl: _quiz.imageUrl,
            ),
            Divider(),
            SummaryRowHeader(
              headerTitle: "Rounds",
            ),
            _quiz.rounds.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _quiz.roundModels?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      RoundModel round = _quiz.roundModels[index];
                      return Column(
                        children: [
                          RoundListItemWithAction(
                            round: round,
                          ),
                          FutureBuilder<RoundModel>(
                            initialData: round,
                            future: Provider.of<RoundService>(context).getRound(
                              id: round.id,
                              token: Provider.of<UserDataStateModel>(context).token,
                            ),
                            builder: (context, snapshot) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.questionModels.length,
                                itemBuilder: (context, index) {
                                  return QuestionListItemWithAction(
                                    question: snapshot.data.questionModels[index],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      );
                    },
                  )
                : DetailsListEmpty(text: "This Quiz has no Rounds"),
          ],
        ),
      ),
    );
  }
}
