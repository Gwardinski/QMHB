import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_add_modal.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class AddRoundToQuizPage extends StatelessWidget {
  final RoundModel roundModel;

  AddRoundToQuizPage({
    @required this.roundModel,
  });

  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: double.minPositive,
        height: 400,
        child: Column(
          children: [
            AddRoundToNewQuizButton(
              initialRound: roundModel,
            ),
            Expanded(
              child: StreamBuilder(
                stream: QuizCollectionService().getQuizzesCreatedByUser(
                  userId: user.uid,
                ),
                builder: (BuildContext context, AsyncSnapshot<List<QuizModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingSpinnerHourGlass(),
                    );
                  }
                  if (snapshot.hasError == true) {
                    print(snapshot.error);
                    return Center(
                      child: Text("Can't load your Quizzes"),
                    );
                  }
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return AddRoundToQuizButton(
                              quizModel: snapshot.data[index],
                              roundModel: roundModel,
                            );
                          },
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddRoundToNewQuizButton extends StatelessWidget {
  AddRoundToNewQuizButton({
    this.initialRound,
  });

  final RoundModel initialRound;

  openNewRoundForm(context) {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizAddModal(
          initialRound: initialRound,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
  }
}

class AddRoundToQuizButton extends StatelessWidget {
  const AddRoundToQuizButton({
    Key key,
    @required this.quizModel,
    @required this.roundModel,
  }) : super(key: key);

  final QuizModel quizModel;
  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    bool remove = quizModel.roundIds.contains(roundModel.id);
    return InkWell(
      onTap: () {
        if (!remove) {
          QuizCollectionService().addRoundToQuiz(quizModel, roundModel);
        } else {
          QuizCollectionService().removeRoundFromQuiz(quizModel, roundModel);
        }
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  quizModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                remove
                    ? Text(
                        "remove",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).accentColor,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
