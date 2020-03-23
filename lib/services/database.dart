import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

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
      final test = UserModel.fromFirebase(user.data);
      return test;
    });
  }

  // Get data from Firebase by ID
  Future<List<QuizModel>> getQuizzesByIds(List<String> quizIds) async {
    List<QuizModel> quizzes = [];
    for (var id in quizIds) {
      DocumentSnapshot fbquiz = await _quizzesCollection.document(id).get();
      QuizModel quiz = QuizModel.fromFirebase(fbquiz);
      quizzes.add(quiz);
    }
    return quizzes;
  }

  Future<List<RoundModel>> getRoundsByIds(List<String> roundIds) async {
    List<RoundModel> rounds = [];
    for (var id in roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      RoundModel round = RoundModel.fromFirebase(fbround);
      rounds.add(round);
    }
    return rounds;
  }

  Future<List<QuestionModel>> getQuestionsByIds(List<String> questionIds) async {
    List<QuestionModel> questions = [];
    for (var id in questionIds) {
      DocumentSnapshot fbquestion = await _questionsCollection.document(id).get();
      QuestionModel question = QuestionModel.fromFirebase(fbquestion);
      questions.add(question);
    }
    return questions;
  }

  // Get all data from Firebase
  // Stream<List<QuizModel>> getAllQuizzes() {
  //   return _quizzesCollection.snapshots().map(_quizModelListFromSnapshot);
  // }

  // Stream<List<RoundModel>> getAllRounds() {
  //   return _roundsCollection.snapshots().map(_roundModelListFromSnapshot);
  // }

  // Stream<List<QuestionModel>> getAllQuestions() {
  //   return _questionsCollection.snapshots().map(_questionModelListFromSnapshot);
  // }
  // Convert Firebase data to App Models
  // List<QuizModel> _quizModelListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((DocumentSnapshot document) {
  //     return QuizModel.fromFirebase(document);
  //   }).toList();
  // }

  // List<RoundModel> _roundModelListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((DocumentSnapshot document) {
  //     return RoundModel.fromFirebase(document);
  //   }).toList();
  // }

  // List<QuestionModel> _questionModelListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((DocumentSnapshot document) {
  //     return QuestionModel.fromFirebase(document);
  //   }).toList();
  // }

  // Update user on Firebase
  Future updateUserData(UserModel userModel) async {
    return await _usersCollection.document(userModel.uid).setData({
      "uid": userModel.uid,
      "displayName": userModel.displayName,
      "email": userModel.email,
      "quizIds": ["4Jv01fxpFzcTkPztl7bT"],
      "lastUpdated": DateTime.now().toString(),
    });
  }
}
