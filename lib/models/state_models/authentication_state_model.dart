import 'package:flutter/material.dart';
import 'package:qmhb/models/user_model.dart';

enum AuthState {
  Authenticated,
  Unauthenticated,
}

class AuthenticationStateModel extends ChangeNotifier {
  static const String UserKey = 'user';
  UserModel _userModel;
  AuthState _authState = AuthState.Unauthenticated;

  UserModel get user => _userModel;
  bool get isAuthenticated => _authState == AuthState.Authenticated;

  updateCurrentUser(UserModel updatedUser) {
    try {
      _userModel = updatedUser;
      _authState = AuthState.Authenticated;
    } catch (error) {
      _authState = AuthState.Unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  void removeCurrentUser() {
    _userModel = null;
    _authState = AuthState.Unauthenticated;
    notifyListeners();
  }
}
