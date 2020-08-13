import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';

class QuizSelectorItem extends StatefulWidget {
  final QuizModel quizModel;
  final String roundId;
  final double roundPoints;

  const QuizSelectorItem({
    @required this.quizModel,
    @required this.roundId,
    @required this.roundPoints,
  });

  @override
  _QuizSelectorItemState createState() => _QuizSelectorItemState();
}

class _QuizSelectorItemState extends State<QuizSelectorItem> {
  bool isLoading;
  @override
  Widget build(BuildContext context) {
    bool hasRound = _quizContainsRound(widget.quizModel);
    return CheckboxListTile(
      title: Text(
        widget.quizModel.title,
        style: TextStyle(
          color: isLoading == true ? Colors.grey : Colors.white,
        ),
      ),
      value: hasRound,
      onChanged: isLoading == true
          ? null
          : (bool value) {
              _addOrRemoveRound(widget.quizModel);
            },
    );
  }

  _quizContainsRound(QuizModel quizModel) {
    return quizModel.roundIds.contains(widget.roundId);
  }

  _addOrRemoveRound(QuizModel quizModel) async {
    try {
      setState(() {
        isLoading = true;
      });
      QuizCollectionService quizService = Provider.of<QuizCollectionService>(context);
      UserCollectionService userService = Provider.of<UserCollectionService>(context);
      UserModel userModel = Provider.of<UserDataStateModel>(context).user;
      if (_quizContainsRound(quizModel)) {
        quizModel.roundIds.remove(widget.roundId);
        quizModel.totalPoints -= widget.roundPoints;
      } else {
        quizModel.roundIds.add(widget.roundId);
        quizModel.totalPoints += widget.roundPoints;
      }
      await quizService.editQuizOnFirebaseCollection(quizModel);
      await userService.updateUserDataOnFirebase(userModel);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
