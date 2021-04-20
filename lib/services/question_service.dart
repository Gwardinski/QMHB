import 'dart:convert';

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

  // LIBRARY
  Future<List<QuestionModel>> getUserQuestions({
    @required String token,
    int limit,
    String sortBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/questions/user/'),
        headers: _getHeaders(token),
      );
      return QuestionModel.listFromJson(res.data);
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
      print(e);
      throw Exception();
    }
  }

  // EXPLORE - all published
  Future<List<QuestionModel>> getAllQuestions({
    String token,
    int limit,
    String sortBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/questions/'),
        headers: _getHeaders(token),
      );
      return QuestionModel.listFromJson(res.data);
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
      print(e);
      throw Exception();
    }
  }

  // Fails when !user and !published
  Future<QuestionModel> getQuestion({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/questions/$id/'),
        headers: _getHeaders(token),
      );
      return QuestionModel.fromJson(res.data);
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
      print(e);
      throw Exception();
    }
  }

  Future<QuestionModel> createQuestion({
    @required QuestionModel question,
    @required String token,
  }) async {
    try {
      final res = await httpService.post(
        Uri.http(baseUrl, '/api/questions/'),
        headers: _getHeaders(token),
        body: json.encode(question),
      );
      return QuestionModel.fromJson(res.data);
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
      print(e);
      throw Exception();
    }
  }

  Future<QuestionModel> editQuestion({
    @required QuestionModel question,
    @required String token,
  }) async {
    try {
      print(json.encode(question));
      final res = await httpService.put(
        Uri.http(baseUrl, 'api/questions/${question.id}/'),
        headers: _getHeaders(token),
        body: json.encode(question),
      );
      return QuestionModel.fromJson(res.data);
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
      print(e);
      throw Exception();
    }
  }

  Future<void> deleteQuestion({
    @required QuestionModel question,
    @required String token,
  }) async {
    try {
      await httpService.delete(
        Uri.http(baseUrl, 'api/questions/${question.id}/'),
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
      print(e);
      throw Exception();
    }
  }

  Map<String, String> _getHeaders(token) {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    return headers;
  }
}
