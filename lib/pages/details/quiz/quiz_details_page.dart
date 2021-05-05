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
import 'package:qmhb/shared/widgets/page_wrapper.dart';
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
  QuizModel _quiz;

  @override
  void initState() {
    super.initState();
    _quiz = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text("Quiz Details"),
        actions: [
          QuizListItemAction(
            quiz: _quiz,
          ),
        ],
      ),
      body: StreamBuilder<bool>(
        stream: Provider.of<RefreshService>(context).quizListener,
        builder: (context, s) {
          return FutureBuilder<QuizModel>(
            initialData: _quiz,
            future: Provider.of<QuizService>(context).getQuiz(
              id: _quiz.id,
              token: Provider.of<UserDataStateModel>(context, listen: false).token,
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("An error occured loading this Quiz"),
                );
              }
              _quiz = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    DetailsHeader(
                      type: "Quiz",
                      title: snapshot.data.title,
                      description: snapshot.data.description,
                      info1Title: "Rounds",
                      info2Title: "Points",
                      info3Title: "Created",
                      info1Value: snapshot.data.rounds.length.toString(),
                      info2Value: snapshot.data.totalPoints.toString(),
                      info3Value: DateFormat('d-MM-yy').format(snapshot.data.createdAt),
                      imageUrl: snapshot.data.imageUrl,
                    ),
                    Divider(),
                    SummaryRowHeader(
                      headerTitle: "Rounds",
                    ),
                    snapshot.data.rounds.length > 0
                        ? ListView.separated(
                            separatorBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16),
                              );
                            },
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.roundModels?.length ?? 0,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              RoundModel round = snapshot.data.roundModels[index];
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
              );
            },
          );
        },
      ),
    );
  }
}
