import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class UserDataStateModel extends ChangeNotifier {
  static const String UserKey = 'user';
  bool _isAuthenticated = false;
  bool _hasInitialised = false;
  UserModel _userModel;
  String _lastUpdated;
  List<QuizModel> _recentQuizzes;
  List<RoundModel> _recentRounds;
  List<QuestionModel> _recentQuestions;

  //TODO store loaded data from network in here
  List<QuizModel> loadedQuizzes;
  List<RoundModel> loadedRounds;
  List<QuestionModel> loadedQuestions;

  UserModel get user => _userModel;
  bool get isAuthenticated => _isAuthenticated;
  bool get hasInitialised => _hasInitialised;
  String get lastUpdated => _lastUpdated;
  List<QuizModel> get recentQuizzes => _recentQuizzes;
  List<RoundModel> get recentRounds => _recentRounds;
  List<QuestionModel> get recentQuestions => _recentQuestions;

  set recentQuizzes(List<QuizModel> quizzes) {
    _recentQuizzes = quizzes;
    _hasInitialised = true;
    notifyListeners();
  }

  set recentRounds(List<RoundModel> rounds) {
    _recentRounds = rounds;
    _hasInitialised = true;
    notifyListeners();
  }

  set recentQuestions(List<QuestionModel> questions) {
    _recentQuestions = questions;
    _hasInitialised = true;
    notifyListeners();
  }

  updateCurrentUser(UserModel updatedUser) {
    try {
      _userModel = updatedUser;
      _lastUpdated = updatedUser.lastUpdated;
      _isAuthenticated = true;
    } catch (error) {
      print(error.toString());
      _isAuthenticated = false;
    } finally {
      notifyListeners();
    }
  }

  void removeCurrentUser() {
    _userModel = null;
    _isAuthenticated = false;
    _hasInitialised = false;
    notifyListeners();
  }
}
