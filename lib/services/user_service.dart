import 'dart:convert';

import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class UserService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "localhost:8000";

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
        Uri.http(baseUrl, ''),
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
    try {
      // TODO - Update API and make single Request
      ServiceResponse authRes = await httpService.post(
        Uri.http(baseUrl, '/api/user/login'),
        body: jsonEncode({
          "username": email,
          "password": password,
        }),
      );
      final token = authRes.data['access'];
      ServiceResponse userRes = await httpService.get(
        Uri.http(baseUrl, '/api/user'),
        headers: {
          'Content-type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      this.userDataStateModel.updateCurrentUser(UserModel.fromJson(userRes.data));
    } on Http400Exception {
      throw BadRequestException();
    } on Http404Exception {
      throw NotFoundException();
    } catch (e) {
      print(e);
      throw Exception();
    }
  }

  void signOut() {
    this.userDataStateModel.removeCurrentUser();
  }
}
