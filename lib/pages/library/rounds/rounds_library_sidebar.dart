import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';

class RoundsLibrarySidebar extends StatelessWidget {
  final QuestionModel selectedQuestion;

  RoundsLibrarySidebar({this.selectedQuestion});

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserDataStateModel>(context).token;
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
          RoundsLibrarySidebarNewRound(),
          RoundsLibrarySidebarHeader(),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<RoundService>(context).getUserRounds(token: token),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError == true) {
                  return ErrorMessage(message: "An error occured loading Your Rounds");
                }
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return ListView.builder(
                    itemCount: snapshot.data.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return RoundsLibrarySidebarItem(
                        roundModel: snapshot.data[index],
                        selectedQuestion: selectedQuestion,
                      );
                    },
                  );
                }
                if (snapshot.hasData && snapshot.data.length == 0) {
                  return Container(
                    child: Center(
                      child: Text("Your Rounds will display here"),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoundsLibrarySidebarNewRound extends StatelessWidget {
  void openNewRoundForm(context, {initialQuestion}) {
    showDialog<void>(
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
    return DragTarget<QuestionModel>(
      onAccept: (question) {
        openNewRoundForm(context, initialQuestion: question);
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            openNewRoundForm(context);
          },
          child: Container(
            height: 64,
            padding: EdgeInsets.all(16),
            child: Center(
              child: Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "New Round",
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
    @required this.roundModel,
    @required this.selectedQuestion,
  });

  final RoundModel roundModel;
  final QuestionModel selectedQuestion;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    return DragTarget<QuestionModel>(
      onWillAccept: (question) => !roundModel.questions.contains(question.id),
      onAccept: (question) {
        roundModel.questions.add(question.id);
        try {
          Provider.of<RoundService>(context, listen: false).editRound(
            round: roundModel,
            token: token,
          );
        } catch (e) {
          print(e);
        }
      },
      builder: (context, canditates, rejects) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoundDetailsPage(
                  roundModel: roundModel,
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
                        roundModel.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedQuestion == null
                              ? Theme.of(context).appBarTheme.color
                              : roundModel.questions.contains(selectedQuestion?.id)
                                  ? Colors.grey
                                  : Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      child: Text(
                        roundModel.questions.length.toString(),
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
                        roundModel.totalPoints.toString(),
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
          ),
        );
      },
    );
  }
}
