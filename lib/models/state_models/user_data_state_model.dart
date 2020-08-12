import 'package:flutter/material.dart';
import 'package:qmhb/models/user_model.dart';

class UserDataStateModel extends ChangeNotifier {
  static const String UserKey = 'user';
  UserModel _userModel;
  bool _isAuthenticated = false;

  UserModel get user => _userModel;
  bool get isAuthenticated => _isAuthenticated;

  updateCurrentUser(UserModel updatedUser) {
    try {
      _userModel = updatedUser;
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
