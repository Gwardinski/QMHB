import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/storage.dart';

class UserDataStateModel extends ChangeNotifier {
  String userKey = 'user';
  LocalStorageService localStorageService;

  UserModel _userModel;
  bool _isAuthenticated = false;

  UserModel get user => _userModel;
  bool get isAuthenticated => _isAuthenticated;
  String get token => _userModel?.authToken ?? null;

  UserDataStateModel({
    @required this.localStorageService,
  }) {
    _init();
  }

  void _init() {
    var userJson = localStorageService.getFromDisk(userKey);
    if (userJson == null) {
      return null;
    }
    updateCurrentUser(
      UserModel.fromJson(
        json.decode(userJson),
      ),
    );
  }

  void updateCurrentUser(UserModel updatedUser) {
    try {
      _userModel = updatedUser;
      _isAuthenticated = true;
      localStorageService.saveStringToDisk(
        userKey,
        json.encode(updatedUser).toString(),
      );
    } catch (error) {
      _isAuthenticated = false;
    } finally {
      notifyListeners();
    }
  }

  void toggleFavouriteQuestion(int id) {
    user.savedQuestions.contains(id) ? user.savedQuestions.remove(id) : user.savedQuestions.add(id);
    notifyListeners();
  }

  void removeQuestion(int id) {
    user.savedQuestions.remove(id);
    notifyListeners();
  }

  void removeCurrentUser() {
    localStorageService.deleteFromDisk(userKey);
    _userModel = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
