import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class RoundService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "localhost:8000";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  RoundService({
    this.httpService,
    this.userDataStateModel,
  });

  Future<List<RoundModel>> getUserRounds({
    @required String token,
    int limit,
    String orderBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/rounds/user'),
        headers: _getHeaders(token),
      );
      return RoundModel.listFromDtos(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<RoundModel>> getAllRounds({
    String token,
    int limit,
    String orderBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return RoundModel.listFromDtos(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<RoundModel> getRound({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return RoundModel.fromDto(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<RoundModel> getRoundWithFullDetails({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return RoundModel.fromDto(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<RoundModel> createRound({
    @required RoundModel round,
    @required String token,
    int initialQuestionId,
    int parentQuizId,
  }) async {
    try {
      ServiceResponse res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: RoundModel.toDtoAdd(
          round,
          initialQuestionId,
          parentQuizId,
        ),
      );
      return RoundModel.fromDto(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<RoundModel> editRound({
    @required RoundModel round,
    @required String token,
  }) async {
    try {
      final res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: RoundModel.toDtoEdit(round),
      );
      return RoundModel.fromDto(res.data);
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> deletetRound({
    @required RoundModel round,
    @required String token,
  }) async {
    try {
      await httpService.delete(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
    } on Http400Exception {
      print('BAD REQUEST');
      throw Exception();
    } on Http403Exception {
      print('FORBIDDEN');
      throw Exception();
    } on Http404Exception {
      print('NOT FOUND');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  Future<RoundModel> addQuestionToRound(
    @required RoundModel round,
    @required QuestionModel question,
  ) {}

  Future<RoundModel> removeQuestionFromRound(
    @required RoundModel round,
    @required QuestionModel question,
  ) {}

  Map<String, String> _getHeaders(token) {
    Map<String, String> headers = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    return headers;
  }
}
