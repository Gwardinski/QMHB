import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/user_model.dart';

class DatabaseService {
  final CollectionReference _usersCollection = Firestore.instance.collection('users');
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  Future<DocumentSnapshot> getUserFromUsersCollectionUsingUID(uid) async {
    return await _usersCollection.document(uid).get();
  }

  // Stream<List<QuizModel>> getUsersQuizzes() {
  //   return _quizzesCollection.snapshots().map(_quizzesListFromSnapshot);
  // }

  // what was I doing again ?

  Future<List<QuizModel>> getUsersQuizzes(List<String> quizIds) async {
    print('loop');
    print(quizIds.toString());
    List<QuizModel> quizzes = [];
    quizIds.forEach((id) async {
      DocumentSnapshot fbquiz = await _quizzesCollection.document(id).get();
      QuizModel quiz = QuizModel.fromFirebase(fbquiz);
      print(quiz.title);
      quizzes.add(quiz);
    });
    return quizzes;
  }

  List<QuizModel> _quizzesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot document) {
      return QuizModel.fromFirebase(document);
    }).toList();
  }

  Stream<List<QuestionModel>> get questions {
    return _questionsCollection.snapshots().map(_questionsListFromSnapshot);
  }

  List<QuestionModel> _questionsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((DocumentSnapshot document) {
      return QuestionModel.fromFirebase(document);
    }).toList();
  }

  Future updateUserData(UserModel userModel) async {
    return await _usersCollection.document(userModel.uid).setData({
      "uid": userModel.uid,
      "displayName": userModel.displayName,
      "email": userModel.email,
      "quizIds": ["4Jv01fxpFzcTkPztl7bT"],
    });
  }
}
