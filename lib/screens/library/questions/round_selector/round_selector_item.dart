import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class RoundSelectorItem extends StatefulWidget {
  final RoundModel roundModel;
  final String questionId;
  final double questionPoints;

  RoundSelectorItem({
    @required this.roundModel,
    @required this.questionId,
    @required this.questionPoints,
  });

  @override
  _RoundSelectorItemState createState() => _RoundSelectorItemState();
}

class _RoundSelectorItemState extends State<RoundSelectorItem> {
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    bool hasQuestion = _roundContainsQuestion(widget.roundModel);
    return CheckboxListTile(
      title: Text(
        widget.roundModel.title,
        style: TextStyle(
          color: isLoading == true ? Colors.grey : Colors.white,
        ),
      ),
      value: hasQuestion,
      onChanged: isLoading == true
          ? null
          : (bool value) {
              _addOrRemoveQuestion(widget.roundModel);
            },
    );
  }

  _roundContainsQuestion(RoundModel roundModel) {
    return roundModel.questionIds.contains(widget.questionId);
  }

  _addOrRemoveQuestion(RoundModel roundModel) async {
    try {
      setState(() {
        isLoading = true;
      });
      DatabaseService databaseService = Provider.of<DatabaseService>(context);
      UserModel userModel = Provider.of<UserDataStateModel>(context).user;
      if (_roundContainsQuestion(roundModel)) {
        roundModel.questionIds.remove(widget.questionId);
        roundModel.totalPoints -= widget.questionPoints;
      } else {
        roundModel.questionIds.add(widget.questionId);
        roundModel.totalPoints += widget.questionPoints;
      }
      await databaseService.editRoundOnFirebase(roundModel, userModel);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
