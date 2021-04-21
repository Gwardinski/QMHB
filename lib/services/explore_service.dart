import 'package:flutter/material.dart';
import 'package:qmhb/models/featured_questions_model.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class ExploreService {
  final baseUrl = "localhost:8000";

  final HttpService httpService;

  ExploreService({
    @required this.httpService,
  });

  Future<FeaturedQuizzes> getFeaturedQuizzes({
    String token,
    String featNo,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.http(baseUrl, 'api/featured/$featNo/'),
        headers: _getHeaders(token),
      );
      return FeaturedQuizzes.fromJson(res.data);
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

  Future<FeaturedRounds> getFeaturedRounds({
    String token,
    String featNo,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.http(baseUrl, 'api/featured/$featNo/'),
        headers: _getHeaders(token),
      );
      return FeaturedRounds.fromJson(res.data);
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

  Future<FeaturedQuestions> getFeaturedQuestions({
    String token,
    String featNo,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.http(baseUrl, 'api/featured/$featNo/'),
        headers: _getHeaders(token),
      );
      return FeaturedQuestions.fromJson(res.data);
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
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    return headers;
  }
}
