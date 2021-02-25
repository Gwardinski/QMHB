import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class QuestionService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "localhost:8000";

  final HttpService httpService;

  QuestionService({
    this.httpService,
  });

  Future<List<QuestionModel>> getUserQuestions({
    @required String token,
    int limit,
    String orderBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/questions/user'),
        headers: _getHeaders(token),
      );
      return QuestionModel.listFromDtos(res.data);
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

  Future<List<QuestionModel>> getAllQuestions({
    String token,
    int limit,
    String orderBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return QuestionModel.listFromDtos(res.data);
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

  Future<QuestionModel> getQuestion({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return QuestionModel.fromDto(res.data);
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

  Future<QuestionModel> getQuestionWithFullDetails({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return QuestionModel.fromDto(res.data);
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

  Future<QuestionModel> createQuestion({
    @required QuestionModel question,
    @required String token,
    int parentRoundId,
  }) async {
    try {
      final res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: QuestionModel.toDtoAdd(
          question,
          parentRoundId,
        ),
      );
      return QuestionModel.fromDto(res.data);
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

  Future<QuestionModel> editQuestion({
    @required QuestionModel question,
    @required String token,
  }) async {
    try {
      final res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: QuestionModel.toDtoEdit(question),
      );
      return QuestionModel.fromDto(res.data);
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

  Future<void> deleteQuestion({
    @required QuestionModel question,
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
