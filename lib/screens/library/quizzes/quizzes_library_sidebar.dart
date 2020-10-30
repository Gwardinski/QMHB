import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/details/quiz/quiz_details_page.dart';
import 'package:qmhb/screens/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuizzesLibrarySidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
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
          UserQuizzesSidebarNewQuiz(),
          UserQuizzesSidebarTitle(),
          Expanded(
            child: StreamBuilder(
              stream: QuizCollectionService().streamQuizzesByIds(
                ids: user.quizIds,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError == true) {
                  return ErrorMessage(message: "An error occured loading your Quizzes");
                }
                return snapshot.data.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return UserQuizzesSidebarItem(quizModel: snapshot.data[index]);
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserQuizzesSidebarTitle extends StatelessWidget {
  const UserQuizzesSidebarTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Quizzes:",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class UserQuizzesSidebarNewQuiz extends StatelessWidget {
  openNewQuizForm(context, {initialRound}) {
    showDialog<void>(
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
    return DragTarget<RoundModel>(
      onAccept: (round) {
        openNewQuizForm(context, initialRound: round);
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            openNewQuizForm(context);
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                  ),
                  Container(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserQuizzesSidebarItem extends StatelessWidget {
  const UserQuizzesSidebarItem({
    @required this.quizModel,
  });

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return DragTarget<RoundModel>(
      onWillAccept: (round) => !quizModel.roundIds.contains(round.id),
      onAccept: (round) {
        QuizCollectionService().addRoundToQuiz(quizModel, round);
      },
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
            padding: EdgeInsets.fromLTRB(32, 16, 16, 16),
            child: Center(
              child: Container(
                width: double.infinity,
                child: Text(
                  quizModel.title,
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
