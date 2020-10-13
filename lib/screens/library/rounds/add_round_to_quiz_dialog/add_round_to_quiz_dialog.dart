import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/rounds/add_round_to_quiz_dialog/add_round_to_new_quiz_button.dart';
import 'package:qmhb/screens/library/rounds/add_round_to_quiz_dialog/add_round_to_quiz_button.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

// Dialog is used for building up: Question => Round => Quiz
class AddRoundToQuizDialog extends StatelessWidget {
  final RoundModel roundModel;

  AddRoundToQuizDialog({
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
                    return ErrorMessage(message: "An error occured loading your Rounds");
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
