import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_list_empty.dart';
import 'package:qmhb/pages/details/widgets/details_header.dart';
import 'package:qmhb/pages/library/add_rounds_to_quiz_page.dart';
import 'package:qmhb/pages/library/reorder_rounds_page.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizDetailsPage extends StatefulWidget {
  const QuizDetailsPage({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

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
    _quiz = widget.quizModel;
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
    final quiz = await _quizService.getQuiz(token: token, id: widget.quizModel.id);
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
        actions: <Widget>[
          QuizListItemAction(
            quizModel: widget.quizModel,
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
              secondaryHeaderButtonText: "Add / Remove",
              secondaryHeaderButtonFunction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddRoundsToQuizPage(
                      selectedQuiz: _quiz,
                    ),
                  ),
                );
              },
              primaryHeaderButtonText: "Reorder",
              primaryHeaderButtonFunction: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReorderRoundsPage(
                      quizModel: _quiz,
                    ),
                  ),
                );
              },
            ),
            _quiz.rounds.length > 0
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                      );
                    },
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _quiz.roundModels?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      RoundModel roundModel = _quiz.roundModels[index];
                      return RoundListItemWithAction(
                        roundModel: roundModel,
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
