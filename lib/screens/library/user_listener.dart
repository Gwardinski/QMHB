import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';

class UserListener extends StatefulWidget {
  final child;
  UserListener({
    @required this.child,
  });

  @override
  _UserListenerState createState() => _UserListenerState();
}

class _UserListenerState extends State<UserListener> {
  bool _hasInitiated = false;

  UserDataStateModel _userDataStateModel;
  @override
  Widget build(BuildContext context) {
    _userDataStateModel = Provider.of<UserDataStateModel>(context);
    UserModel currentUserModel = _userDataStateModel.user;
    // Todo - use singleton here ?
    return StreamBuilder(
      stream: UserCollectionService().getUserStream(currentUserModel?.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          UserModel newUserModel = snapshot.data;
          bool hasUpdated = newUserModel.lastUpdated != currentUserModel.lastUpdated;
          if (hasUpdated || !_hasInitiated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _hasInitiated = true;
              });
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
    final questionService = Provider.of<QuestionCollectionService>(context);
    final roundService = Provider.of<RoundCollectionService>(context);
    final quizService = Provider.of<QuizCollectionService>(context);
    final recentActivity = Provider.of<RecentActivityStateModel>(context);
    List<QuizModel> recentQuizzes;
    List<RoundModel> recentRounds;
    List<QuestionModel> recentQuestions;
    // TODO - remove all these and just do a normal request filtered by FirebaseServerTime
    recentQuizzes = await quizService.getQuizzesByIds(newUserModel.quizIds);
    recentRounds = await roundService.getRoundsByIds(newUserModel.roundIds);
    recentQuestions = await questionService.getQuestionsByIds(newUserModel.questionIds);

    recentActivity.updateRecentActivity(
      quizzes: recentQuizzes,
      rounds: recentRounds,
      questions: recentQuestions,
    );
  }
}
