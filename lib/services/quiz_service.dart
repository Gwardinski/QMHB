import 'package:flutter/cupertino.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class QuizService extends ChangeNotifier {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "localhost:8000";

  final HttpService httpService;

  QuizService({
    @required this.httpService,
  });

  Future<List<QuizModel>> getUserQuizzes({
    @required String token,
    int limit,
    String orderBy,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.http(baseUrl, '/api/quizzes/user'),
        headers: _getHeaders(token),
      );
      return QuizModel.listFromDtos(res.data);
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

  Future<List<QuizModel>> getAllQuizzes({
    String token,
    int limit,
    String orderBy,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return QuizModel.listFromDtos(res.data);
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

  Future<QuizModel> getQuiz({
    @required int id,
    String token,
  }) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
      );
      return QuizModel.fromDto(res.data);
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

  Future<QuizModel> createQuiz({
    @required QuizModel quiz,
    @required String token,
    int initialRoundId,
  }) async {
    try {
      ServiceResponse res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: QuizModel.toDtoAdd(
          quiz,
          initialRoundId,
        ),
      );
      return QuizModel.fromDto(res.data);
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

  Future<QuizModel> editQuiz({
    @required QuizModel quiz,
    @required String token,
  }) async {
    try {
      ServiceResponse res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(token),
        body: QuizModel.toDtoEdit(quiz),
      );
      return QuizModel.fromDto(res.data);
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

  Future<void> deleteQuiz({
    @required QuizModel quiz,
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

  Future<QuizModel> addRoundToQuiz(
    @required QuizModel quiz,
    @required RoundModel round,
  ) {}

  Future<QuizModel> removeRoundFromQuiz(
    @required QuizModel quiz,
    @required RoundModel round,
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
