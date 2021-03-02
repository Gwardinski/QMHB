import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/Quizzes/Quiz_create_dialog.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_new_item_button.dart';
import 'package:qmhb/services/Quiz_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class AddRoundToQuizzesPage extends StatefulWidget {
  final RoundModel selectedRound;

  AddRoundToQuizzesPage({
    @required this.selectedRound,
  });

  @override
  _AddRoundToQuizzesPageState createState() => _AddRoundToQuizzesPageState();
}

class _AddRoundToQuizzesPageState extends State<AddRoundToQuizzesPage> {
  String _token;
  QuizService _quizService;

  void createNewQuizwithRound(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizCreateDialog(
          initialRound: widget.selectedRound,
        );
      },
    );
  }

  bool _containsRound(quizModel) {
    return quizModel.rounds.contains(widget.selectedRound.id);
  }

  Future<void> _updateQuiz(quizModel) async {
    QuizModel quiz = quizModel;
    if (_containsRound(quizModel)) {
      quiz.rounds.remove(widget.selectedRound.id);
    } else {
      quiz.rounds.add(widget.selectedRound.id);
    }
    await _quizService.editQuiz(
      quiz: quiz,
      token: _token,
    );
  }

  Widget build(BuildContext context) {
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _quizService = Provider.of<QuizService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to Quizzes"),
      ),
      body: Column(
        children: [
          Container(
            child: Text(
              widget.selectedRound.title,
            ),
          ),
          Container(
            child: Text(
              "From here you can select the Quizzes that you wish to add this Round to. You can also de-select a Quiz to remove it.",
            ),
          ),
          AddItemIntoNewItemButton(
            title: "Add to New Quiz",
            onTap: () {
              createNewQuizwithRound(context);
            },
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<QuizService>(context).getUserQuizzes(
                token: _token,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<QuizModel>> snapshot) {
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
                          return AddItemIntoItemButton(
                            title: snapshot.data[index].title,
                            onTap: () async {
                              await _updateQuiz(snapshot.data[index]);
                            },
                            doesContain: _containsRound(snapshot.data[index]),
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
