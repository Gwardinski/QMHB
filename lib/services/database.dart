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

  // Get all data from Firebase
  Stream<List<QuizModel>> getAllQuizzes() {
    return _quizzesCollection.snapshots().map(_quizModelListFromSnapshot);
  }

  Stream<List<RoundModel>> getAllRounds() {
    return _roundsCollection.snapshots().map(_roundModelListFromSnapshot);
  }

  Stream<List<QuestionModel>> getAllQuestions() {
    return _questionsCollection.snapshots().map(_questionModelListFromSnapshot);
  }

  // Get user data from Firebase
  Future<List<QuizModel>> getUsersQuizzes(List<String> quizIds) async {
    List<QuizModel> quizzes = [];
    quizIds.forEach((id) async {
      DocumentSnapshot fbquiz = await _quizzesCollection.document(id).get();
      QuizModel quiz = QuizModel.fromFirebase(fbquiz);
      quizzes.add(quiz);
    });
    return quizzes;
  }

  Future<List<RoundModel>> getUsersRounds(List<String> roundIds) async {
    List<RoundModel> rounds = [];
    roundIds.forEach((id) async {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      RoundModel quiz = RoundModel.fromFirebase(fbround);
      rounds.add(quiz);
    });
    return rounds;
  }

  Future<List<RoundModel>> getUsersQuestions(List<String> questionIds) async {
    List<RoundModel> questions = [];
    questionIds.forEach((id) async {
      DocumentSnapshot fbquestion = await _questionsCollection.document(id).get();
      RoundModel quiz = RoundModel.fromFirebase(fbquestion);
      questions.add(quiz);
    });
    return questions;
  }

  // Convert Firebase data to App Models
  List<QuizModel> _quizModelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot document) {
      return QuizModel.fromFirebase(document);
    }).toList();
  }

  List<RoundModel> _roundModelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot document) {
      return RoundModel.fromFirebase(document);
    }).toList();
  }

  List<QuestionModel> _questionModelListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot document) {
      return QuestionModel.fromFirebase(document);
    }).toList();
  }

  // Update user on Firebase
  Future updateUserData(UserModel userModel) async {
    return await _usersCollection.document(userModel.uid).setData({
      "uid": userModel.uid,
      "displayName": userModel.displayName,
      "email": userModel.email,
      "quizIds": ["4Jv01fxpFzcTkPztl7bT"],
    });
  }
}
