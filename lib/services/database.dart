import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

// TODO - refactor out to seperate collection services
class DatabaseService {
  // DB collections
  final CollectionReference _usersCollection = Firestore.instance.collection('users');
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');
  final CollectionReference _roundsCollection = Firestore.instance.collection('rounds');
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  // Log in user
  Future<DocumentSnapshot> getUserFromUsersCollectionUsingUID(uid) async {
    return await _usersCollection.document(uid).get();
  }

  // stream user changes - called on base widget UserListener
  Stream<UserModel> getUserStream(id) {
    return _usersCollection.document(id).snapshots().map((user) {
      return UserModel.fromFirebase(user.data);
    });
  }

  // TODO handle this in single request
  Future<List<QuizModel>> getQuizzesByIds(List<String> quizIds) async {
    List<QuizModel> quizzes = [];
    for (var id in quizIds) {
      DocumentSnapshot fbquiz = await _quizzesCollection.document(id).get();
      try {
        QuizModel quiz = QuizModel.fromFirebase(fbquiz, id);
        quizzes.add(quiz);
      } catch (e) {
        print("failed to find quiz with ID of $id");
      }
    }
    return quizzes;
  }

  // TODO handle this in single request
  Future<List<RoundModel>> getRoundsByIds(List<String> roundIds) async {
    List<RoundModel> rounds = [];
    for (var id in roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      try {
        RoundModel round = RoundModel.fromFirebase(fbround, id);
        rounds.add(round);
      } catch (e) {
        print("failed to find round with ID of $id");
      }
    }
    return rounds;
  }

  // Questions

  deleteQuestion(UserModel user, QuestionModel question) async {
    await _removeQuestionFromAllRounds(user, question);
    await _removeQuestionUser(user, question);
    await _questionsCollection.document(question.uid).delete();
  }

  _removeQuestionFromAllRounds(UserModel user, QuestionModel question) async {
    for (var id in user.roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      try {
        RoundModel round = RoundModel.fromFirebase(fbround, id);
        round.questionIds.remove(question.uid);
        round.totalPoints -= question.points;
        // await _editRoundOnFirebaseCollection(round, user.uid);
      } catch (e) {
        print("failed to find round with ID of $id");
      }
    }
  }

  _removeQuestionUser(UserModel user, QuestionModel question) async {
    user.questionIds.remove(question.uid);
    // await updateUserDataOnFirebase(user);
  }
}
