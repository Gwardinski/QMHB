import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/rounds/round_add_modal.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class AddQuestionToRoundPage extends StatelessWidget {
  final QuestionModel questionModel;

  AddQuestionToRoundPage({
    @required this.questionModel,
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
            AddQuestionToNewRoundButton(
              initialQuestion: questionModel,
            ),
            Expanded(
              child: StreamBuilder(
                stream: RoundCollectionService().getRoundsCreatedByUser(
                  userId: user.uid,
                ),
                builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingSpinnerHourGlass(),
                    );
                  }
                  if (snapshot.hasError == true) {
                    print(snapshot.error);
                    return Center(
                      child: Text("Can't load your Rounds"),
                    );
                  }
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return AddQuestionToRoundButton(
                              roundModel: snapshot.data[index],
                              questionModel: questionModel,
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

class AddQuestionToNewRoundButton extends StatelessWidget {
  AddQuestionToNewRoundButton({
    this.initialQuestion,
  });

  final QuestionModel initialQuestion;

  openNewRoundForm(context) {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundAddModal(
          initialQuestion: initialQuestion,
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
  }
}

class AddQuestionToRoundButton extends StatelessWidget {
  const AddQuestionToRoundButton({
    Key key,
    @required this.roundModel,
    @required this.questionModel,
  }) : super(key: key);

  final RoundModel roundModel;
  final QuestionModel questionModel;

  @override
  Widget build(BuildContext context) {
    bool remove = roundModel.questionIds.contains(questionModel.id);
    return InkWell(
      onTap: () {
        if (!remove) {
          RoundCollectionService().addQuestionToRound(roundModel, questionModel);
        } else {
          RoundCollectionService().removeQuestionToRound(roundModel, questionModel);
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
                  roundModel.title,
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
