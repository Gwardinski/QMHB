import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class QuizSelector extends StatefulWidget {
  final QuizModel quizModel;
  final String roundId;
  final double roundPoints;

  const QuizSelector({
    @required this.quizModel,
    @required this.roundId,
    @required this.roundPoints,
  });

  @override
  _QuizSelectorState createState() => _QuizSelectorState();
}

class _QuizSelectorState extends State<QuizSelector> {
  @override
  Widget build(BuildContext context) {
    bool hasQuestion = _quizContainsRound(widget.quizModel);
    return CheckboxListTile(
      title: Text(widget.quizModel.title),
      value: hasQuestion,
      onChanged: (bool value) {
        _addOrRemoveRound(widget.quizModel);
      },
    );
  }

  _quizContainsRound(QuizModel quizModel) {
    return quizModel.roundIds.contains(widget.roundId);
  }

  _addOrRemoveRound(QuizModel quizModel) async {
    try {
      DatabaseService databaseService = Provider.of<DatabaseService>(context);
      UserModel userModel = Provider.of<UserDataStateModel>(context).user;
      if (_quizContainsRound(quizModel)) {
        quizModel.roundIds.remove(widget.roundId);
        quizModel.totalPoints -= widget.roundPoints;
      } else {
        quizModel.roundIds.add(widget.roundId);
        quizModel.totalPoints += widget.roundPoints;
      }
      await databaseService.editQuizOnFirebase(quizModel, userModel);
    } catch (e) {
      print(e.toString());
    }
  }
}
