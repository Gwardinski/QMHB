import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_header.dart';
import 'package:qmhb/pages/library/widgets/library_side_bar_item.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';

class RoundsLibrarySidebar extends StatelessWidget {
  final QuestionModel selectedQuestion;

  RoundsLibrarySidebar({
    @required this.selectedQuestion,
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
          selectedQuestion != null
              ? RoundsLibrarySidebarNewRound(
                  onCreateNewRound: (initialQuestion) {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RoundCreateDialog(
                          initialQuestion: initialQuestion,
                        );
                      },
                    );
                  },
                )
              : LibarySidebarHeader(
                  title: "Your Rounds",
                  header1: "Title",
                  tooltip1: "Round Title",
                  header2: "Qs",
                  tooltip2: "No of Questions",
                  header3: "Pts",
                  tooltip3: "Total Points",
                  edgePadding: false,
                ),
          Expanded(
            child: StreamBuilder<bool>(
              stream: Provider.of<RefreshService>(context).roundListener,
              builder: (context, s) {
                return FutureBuilder<List<RoundModel>>(
                  future: Provider.of<RoundService>(context).getUserRounds(
                    token: Provider.of<UserDataStateModel>(context, listen: false).token,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return ErrorMessage(message: "An error occured loading your Rounds");
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return RoundsLibrarySidebarItem(
                          round: snapshot.data[index],
                          selectedQuestion: selectedQuestion,
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

class RoundsLibrarySidebarItem extends StatelessWidget {
  const RoundsLibrarySidebarItem({
    @required this.round,
    @required this.selectedQuestion,
  });

  final RoundModel round;
  final QuestionModel selectedQuestion;

  onAcceptNewQuestion(context, QuestionModel question) async {
    UserDataStateModel userDataStateModel = Provider.of<UserDataStateModel>(context, listen: false);
    final token = userDataStateModel.token;
    final userService = Provider.of<UserService>(context, listen: false);
    final roundService = Provider.of<RoundService>(context, listen: false);
    final refreshService = Provider.of<RefreshService>(context, listen: false);
    try {
      bool favourited = false;
      final updatedRound = round;
      updatedRound.questions.add(selectedQuestion.id);
      if ((question.uid != userDataStateModel.user.id) &&
          !userDataStateModel.user.savedQuestions.contains(question.id)) {
        userDataStateModel.toggleFavouriteQuestion(question.id);
        await userService.toggleFavouriteQuestion(id: question.id, token: token);
        favourited = true;
      }
      await roundService.editRound(
        round: updatedRound,
        token: token,
      );
      _showSnackbar(context, favourited);
      favourited ? refreshService.roundRefresh() : refreshService.roundAndQuestionRefresh();
    } catch (e) {
      print(e);
    }
  }

  void _showSnackbar(context, bool favourited) {
    final snackBar = SnackBar(
      content: Text("Question${favourited ? ' favourited and ' : ' '}added to ${round.title}"),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).accentColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<QuestionModel>(
      onWillAccept: (question) => !round.questions.contains(question.id),
      onAccept: (question) => onAcceptNewQuestion(context, question),
      builder: (context, canditates, rejects) {
        return LibrarySideBarItem(
          lowlight: selectedQuestion != null,
          highlight: selectedQuestion != null && !round.questions.contains(selectedQuestion?.id),
          title: round.title,
          val1: round.questions.length.toString(),
          val2: round.totalPoints.toString(),
          onTap: () {
            Provider.of<NavigationService>(context, listen: false).push(
              RoundDetailsPage(
                initialValue: round,
              ),
            );
          },
        );
      },
    );
  }
}
