import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class RoundService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "http://127.0.0.1:8000/api";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  RoundService({
    this.httpService,
    this.userDataStateModel,
  });

  Future<List<RoundModel>> getUserRounds({int limit, String orderBy}) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<List<RoundModel>> getAllRounds({int limit, String orderBy}) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<RoundModel> getRound(int id) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<RoundModel> getRoundWithFullDetails(int id) async {
    try {
      final res = await httpService.get(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<RoundModel> createRound(
    RoundModel round, {
    int initialQuestionId,
    int parentQuizId,
  }) async {
    try {
      ServiceResponse res = await httpService.post(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<RoundModel> editRound(RoundModel round) async {
    try {
      final res = await httpService.put(
        Uri.https(baseUrl, ''),
        headers: _getHeaders(),
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

  Future<void> deletetRound(RoundModel round) async {
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

  Future<RoundModel> addQuestionToRound(
    RoundModel round,
    QuestionModel question,
  ) {}

  Future<RoundModel> removeQuestionFromRound(
    RoundModel round,
    QuestionModel question,
  ) {}

  Map<String, String> _getHeaders() {
    return {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer ${userDataStateModel.token}",
    };
  }
}
