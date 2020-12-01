import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/http_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';

class RoundService {
  // final baseUrl = "https://quizflow.azurewebsites.net";
  final baseUrl = "https://10.0.2.2:5001";

  final HttpService httpService;
  final UserDataStateModel userDataStateModel;

  RoundService({
    this.httpService,
    this.userDataStateModel,
  });

  Future<List<RoundModel>> getUserRounds({int limit, String orderBy}) async {
    try {
      final res = await httpService.get(
        '$baseUrl/rounds',
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
        '$baseUrl/rounds/all',
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
        '$baseUrl/rounds/$id',
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
        '$baseUrl/rounds/$id/all',
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
        '$baseUrl/rounds',
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
        '$baseUrl/rounds',
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
        '$baseUrl/rounds/${round.id}',
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
