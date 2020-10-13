import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/details/round/round_details_page.dart';
import 'package:qmhb/screens/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundsLibrarySidebar extends StatelessWidget {
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
          RoundsLibrarySidebarNewRound(),
          Expanded(
            child: StreamBuilder(
              stream: RoundCollectionService().getRoundsCreatedByUser(
                userId: user.uid,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError == true) {
                  return ErrorMessage(message: "An error occured loading Your Rounds");
                }
                return snapshot.data.length > 0
                    ? ListView.builder(
                        itemCount: snapshot.data.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return RoundsLibrarySidebarItem(roundModel: snapshot.data[index]);
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

class RoundsLibrarySidebarNewRound extends StatelessWidget {
  openNewRoundForm(context, {initialQuestion}) {
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
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle,
                  ),
                  Container(
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
                ],
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
    @required this.roundModel,
  });

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return DragTarget<QuestionModel>(
      onWillAccept: (question) => !roundModel.questionIds.contains(question.id),
      onAccept: (question) {
        RoundCollectionService().addQuestionToRound(roundModel, question);
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
            padding: EdgeInsets.fromLTRB(32, 16, 16, 16),
            child: Center(
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      roundModel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      roundModel.questionIds.length.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
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
