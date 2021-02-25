import 'package:flutter/cupertino.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class QuizService extends ChangeNotifier {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "http://127.0.0.1:8000/api";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  QuizService({
    @required this.httpService,
    @required this.userDataStateModel,
  });

  Future<List<QuizModel>> getUserQuizzes({int limit, String orderBy}) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<List<QuizModel>> getAllQuizzes({int limit, String orderBy}) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuizModel> getQuiz(int id) async {
    try {
      ServiceResponse res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuizModel> createQuiz(
    QuizModel quiz, {
    int initialRoundId,
  }) async {
    try {
      ServiceResponse res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuizModel> editQuiz(QuizModel quiz) async {
    try {
      ServiceResponse res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<void> deleteQuiz(QuizModel quiz) async {
    try {
      await httpService.delete(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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
    QuizModel quiz,
    RoundModel round,
  ) {}

  Future<QuizModel> removeRoundFromQuiz(
    QuizModel quiz,
    RoundModel round,
  ) {}

  Map<String, String> _getHeaders() {
    return {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${userDataStateModel.token}",
    };
  }
}
