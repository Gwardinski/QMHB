import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/questions/add_question_to_round_dialog/add_question_to_new_round_button.dart';
import 'package:qmhb/screens/library/questions/add_question_to_round_dialog/add_question_to_round_button.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

// Dialog is used for building up: Question => Round => Quiz
class AddQuestionToRoundPageDialog extends StatelessWidget {
  final QuestionModel questionModel;

  AddQuestionToRoundPageDialog({
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
                    return ErrorMessage(message: "An error occured loading your Questions");
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
