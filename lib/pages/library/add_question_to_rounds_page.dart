import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class AddQuestionToRoundsPage extends StatefulWidget {
  final QuestionModel selectedQuestion;

  AddQuestionToRoundsPage({
    @required this.selectedQuestion,
  });

  @override
  _AddQuestionToRoundsPageState createState() => _AddQuestionToRoundsPageState();
}

class _AddQuestionToRoundsPageState extends State<AddQuestionToRoundsPage> {
  String _token;
  RoundService _roundService;

  void createNewRoundwithQuestion(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: widget.selectedQuestion,
        );
      },
    );
  }

  bool _containsQuestion(roundModel) {
    return roundModel.questions.contains(widget.selectedQuestion.id);
  }

  Future<void> _updateRound(roundModel) async {
    RoundModel round = roundModel;
    if (_containsQuestion(roundModel)) {
      round.questions.remove(widget.selectedQuestion.id);
    } else {
      round.questions.add(widget.selectedQuestion.id);
    }
    await _roundService.editRound(
      round: round,
      token: _token,
    );
  }

  Widget build(BuildContext context) {
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _roundService = Provider.of<RoundService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to Rounds"),
      ),
      body: Column(
        children: [
          Container(
            child: Text(
              widget.selectedQuestion.question,
            ),
          ),
          Container(
            child: Text(
              "From here you can select the Rounds that you wish to add this Question to. You can also de-select a Round to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add to New Round",
            onTap: () {
              createNewRoundwithQuestion(context);
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<RoundService>(context).getUserRounds(
                token: _token,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> snapshot) {
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
                          return AddItemIntoItemButton(
                            title: snapshot.data[index].title,
                            onTap: () async {
                              await _updateRound(snapshot.data[index]);
                            },
                            doesContain: _containsQuestion(snapshot.data[index]),
                          );
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
