import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class UserListener extends StatefulWidget {
  final child;
  UserListener({
    @required this.child,
  });

  @override
  _UserListenerState createState() => _UserListenerState();
}

class _UserListenerState extends State<UserListener> {
  UserDataStateModel _userDataStateModel;
  @override
  Widget build(BuildContext context) {
    _userDataStateModel = Provider.of<UserDataStateModel>(context);
    UserModel userModel = _userDataStateModel.user;
    String lastUpdated = _userDataStateModel.lastUpdated;
    bool hasInitialised = _userDataStateModel.hasInitialised;
    return StreamBuilder(
      stream: DatabaseService().getUserStream(userModel.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserModel newUserModel = snapshot.data;
          UserModel currentUserModel = _userDataStateModel.user;
          bool hasUpdated = newUserModel.lastUpdated != lastUpdated;
          if (hasUpdated || !hasInitialised) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _userDataStateModel.hasInitialised = true;
              _updateRecentActivity(
                newUserModel: newUserModel,
                currentUserModel: currentUserModel,
              );
              _userDataStateModel.updateCurrentUser(newUserModel);
            });
          }
        }
        return widget.child;
      },
    );
  }

  _updateRecentActivity({UserModel newUserModel, UserModel currentUserModel}) async {
    print("_updateRecentActivity");
    final databaseService = Provider.of<DatabaseService>(context);
    List<QuizModel> recentQuizzes;
    List<RoundModel> recentRounds;
    List<QuestionModel> recentQuestions;
    if (newUserModel.recentQuizIds != currentUserModel.recentQuizIds) {
      print('get recent quizzes');
      recentQuizzes = await databaseService.getQuizzesByIds(
        newUserModel.recentQuizIds,
      );
    }
    if (newUserModel.recentRoundIds != currentUserModel.recentRoundIds) {
      print('get recent rounds');
      recentRounds = await databaseService.getRoundsByIds(
        newUserModel.recentRoundIds,
      );
    }
    if (newUserModel.recentQuestionIds != currentUserModel.recentQuestionIds) {
      print('get recent questions');
      recentQuestions = await databaseService.getQuestionsByIds(
        newUserModel.recentQuestionIds,
      );
    }
    _userDataStateModel.updateRecentActivity(
      quizzes: recentQuizzes,
      rounds: recentRounds,
      questions: recentQuestions,
    );
  }
}
