import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class RoundSelector extends StatefulWidget {
  final RoundModel roundModel;
  final String questionId;

  const RoundSelector({
    @required this.roundModel,
    @required this.questionId,
  });

  @override
  _RoundSelectorState createState() => _RoundSelectorState();
}

class _RoundSelectorState extends State<RoundSelector> {
  @override
  Widget build(BuildContext context) {
    bool hasQuestion = _roundContainsQuestion(widget.roundModel);
    return CheckboxListTile(
      title: Text(widget.roundModel.title),
      value: hasQuestion,
      onChanged: (bool value) {
        _addOrRemoveQuestion(widget.roundModel);
      },
    );
  }

  _roundContainsQuestion(RoundModel roundModel) {
    return roundModel.questionIds.contains(widget.questionId);
  }

  _addOrRemoveQuestion(RoundModel roundModel) async {
    try {
      DatabaseService databaseService = Provider.of<DatabaseService>(context);
      UserModel userModel = Provider.of<UserDataStateModel>(context).user;
      if (_roundContainsQuestion(roundModel)) {
        roundModel.questionIds.remove(widget.questionId);
      } else {
        roundModel.questionIds.add(widget.questionId);
      }
      await databaseService.editRoundOnFirebase(roundModel, userModel);
    } catch (e) {
      print(e.toString());
    }
  }
}
