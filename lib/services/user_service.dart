import 'dart:convert';

import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class UserService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "https://10.0.2.2:5001";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  UserService({
    this.httpService,
    this.userDataStateModel,
  });

  Future<void> registerWithEmailAndPassword({
    String email,
    String password,
    String displayName,
  }) async {
    try {
      await httpService.post(
        '$baseUrl/auth/register',
        body: jsonEncode({
          "email": email,
          "password": password,
          "displayName": displayName,
        }),
      );
    } on Http400Exception {
      throw BadRequestException();
    } on Http409Exception {
      throw ConflictException();
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> signInWithEmailAndPassword({
    String email,
    String password,
  }) async {
    print("signInWithEmailAndPassword");
    print(email);
    print(password);
    try {
      ServiceResponse res = await httpService.post(
        '$baseUrl/auth/login',
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      this.userDataStateModel.updateCurrentUser(UserModel.fromDto(res.data));
    } on Http400Exception {
      throw BadRequestException();
    } on Http404Exception {
      throw NotFoundException();
    } catch (e) {
      throw Exception();
    }
  }

  void signOut() {
    this.userDataStateModel.removeCurrentUser();
  }
}
