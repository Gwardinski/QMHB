import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class UserDataStateModel extends ChangeNotifier {
  static const String UserKey = 'user';
  bool _isAuthenticated = false;
  UserModel _userModel;
  String _lastUpdated;
  List<QuizModel> _recentQuizzes;
  List<RoundModel> _recentRounds;
  List<QuestionModel> _recentQuestions;

  UserModel get user => _userModel;
  bool get isAuthenticated => _isAuthenticated;
  String get lastUpdated => _lastUpdated;
  List<QuizModel> get recentQuizzes => _recentQuizzes;
  List<RoundModel> get recentRounds => _recentRounds;
  List<QuestionModel> get recentQuestions => _recentQuestions;

  set recentQuizzes(List<QuizModel> quizzes) {
    _recentQuizzes = quizzes;
    notifyListeners();
  }

  set recentRounds(List<RoundModel> rounds) {
    _recentRounds = rounds;
    notifyListeners();
  }

  set recentQuestions(List<QuestionModel> questions) {
    _recentQuestions = questions;
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
    notifyListeners();
  }
}
