import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_header.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_item.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';

class QuizzesLibrarySidebar extends StatelessWidget {
  final RoundModel selectedRound;

  QuizzesLibrarySidebar({
    this.selectedRound,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
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
          selectedRound != null
              ? QuizzesLibrarySidebarNewQuiz(
                  onCreateNewQuiz: (initialRound) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return QuizCreateDialog(
                          initialRound: initialRound,
                        );
                      },
                    );
                  },
                )
              : LibarySidebarHeader(
                  title: "Your Quizzes",
                  header1: "Title",
                  tooltip1: "Quiz Title",
                  header2: "Rds",
                  tooltip2: "No of Rounds",
                  header3: "Pts",
                  tooltip3: "Total Points",
                  edgePadding: false,
                ),
          Expanded(
            child: StreamBuilder<bool>(
              stream: Provider.of<RefreshService>(context, listen: false).quizListener,
              builder: (context, s) {
                return FutureBuilder<List<QuizModel>>(
                  future: Provider.of<QuizService>(context).getUserQuizzes(
                    token: Provider.of<UserDataStateModel>(context, listen: false).token,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorMessage(message: "An error occured loading your Quizzes");
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return QuizzesLibrarySidebarItem(
                          quiz: snapshot.data[index],
                          selectedRound: selectedRound,
                        );
                      },
                    );
                  },
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
                child: Text(
                  "Add to New Quiz",
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

class QuizzesLibrarySidebarItem extends StatelessWidget {
  const QuizzesLibrarySidebarItem({
    @required this.quiz,
    @required this.selectedRound,
  });

  final QuizModel quiz;
  final RoundModel selectedRound;

  onAcceptNewQuestion(context, question) async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final quizService = Provider.of<QuizService>(context, listen: false);
    final refreshService = Provider.of<RefreshService>(context, listen: false);
    try {
      final updatedQuiz = quiz;
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
      onWillAccept: (question) => !quiz.rounds.contains(question.id),
      onAccept: (question) => onAcceptNewQuestion(context, question),
      builder: (context, canditates, rejects) {
        return LibrarySideBarItem(
          title: quiz.title,
          lowlight: selectedRound != null,
          highlight: selectedRound != null && !quiz.rounds.contains(selectedRound?.id),
          val1: quiz.rounds.length.toString(),
          val2: quiz.totalPoints.toString(),
          onTap: () {
            Provider.of<NavigationService>(context, listen: false).push(
              QuizDetailsPage(
                initialValue: quiz,
              ),
            );
          },
        );
      },
    );
  }
}
