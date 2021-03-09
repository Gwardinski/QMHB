import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class RoundService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "localhost:8000";

  final HttpService httpService;

  RoundService({
    this.httpService,
  });

  // LIBRARY
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
      return RoundModel.listFromJson(res.data);
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

  // EXPLORE - all published
  Future<List<RoundModel>> getAllRounds({
    String token,
    int limit,
    String orderBy,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/rounds/'),
        headers: _getHeaders(token),
      );
      return RoundModel.listFromJson(res.data);
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

  // Fails when !user and !published
  Future<RoundModel> getRound({
    @required int id,
    String token,
  }) async {
    try {
      final res = await httpService.get(
        Uri.http(baseUrl, '/api/rounds/$id/'),
        headers: _getHeaders(token),
      );
      return RoundModel.fromJson(res.data);
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
  }) async {
    try {
      print(json.encode(round));
      final res = await httpService.post(
        Uri.http(baseUrl, '/api/rounds/'),
        headers: _getHeaders(token),
        body: json.encode(round),
      );
      return RoundModel.fromJson(res.data);
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
        Uri.http(baseUrl, 'api/rounds/${round.id}/'),
        headers: _getHeaders(token),
        body: json.encode(round),
      );
      return RoundModel.fromJson(res.data);
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

  Future<void> deletetRound({
    @required RoundModel round,
    @required String token,
  }) async {
    try {
      await httpService.delete(
        Uri.http(baseUrl, 'api/rounds/${round.id}/'),
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
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    return headers;
  }
}
