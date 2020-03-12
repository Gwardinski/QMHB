import 'package:flutter/material.dart';
import 'package:qmhb/models/user_model.dart';

enum AuthState { Authenticated, Unauthenticated }

class AuthenticationStateModel extends ChangeNotifier {
  UserModel _userModel;
  AuthState _authState = AuthState.Unauthenticated;
  static const String UserKey = 'user';
  // LocalStorageService localStorageService;

  UserModel get user => _userModel;
  bool get isAuthenticated => _authState == AuthState.Authenticated;

  AuthenticationStateModel();

  // void _init() {
  //   var userJson = localStorageService.getFromDisk(UserKey);
  //   if (userJson == null) {
  //     return null;
  //   }
  //   updateCurrentUser(
  //     UserModel.fromJson(
  //       json.decode(userJson),
  //     ),
  //   );
  // }

  updateCurrentUser(UserModel updatedUser) {
    try {
      _userModel = updatedUser;
      // localStorageService.saveStringToDisk(
      //   UserKey,
      //   json.encode(_currentUser).toString(),
      // );
      _authState = AuthState.Authenticated;
    } catch (error) {
      _authState = AuthState.Unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  void removeCurrentUser() {
    // localStorageService.deleteFromDisk(UserKey);
    _userModel = null;
    _authState = AuthState.Unauthenticated;
    notifyListeners();
  }
}
