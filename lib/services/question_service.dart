import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class QuestionService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "http://127.0.0.1:8000/api";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  QuestionService({
    this.httpService,
    this.userDataStateModel,
  });

  Future<List<QuestionModel>> getUserQuestions(
      {int limit, String orderBy}) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<List<QuestionModel>> getAllQuestions(
      {int limit, String orderBy}) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuestionModel> getQuestion(int id) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuestionModel> getQuestionWithFullDetails(int id) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuestionModel> createQuestion(
    QuestionModel question, {
    int parentRoundId,
  }) async {
    try {
      final res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<QuestionModel> editQuestion(QuestionModel question) async {
    try {
      final res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<void> deleteQuestion(QuestionModel question) async {
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

  Map<String, String> _getHeaders() {
    return {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${userDataStateModel.token}",
    };
  }
}
