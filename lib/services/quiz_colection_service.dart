import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/quiz_model.dart';

class QuizCollectionService {
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');

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

  Future addQuizToFirebaseCollection(QuizModel quizModel, String uid) async {
    final serverTimestamp = FieldValue.serverTimestamp();
    return await _quizzesCollection.add({
      "uid": uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> editQuizOnFirebaseCollection(QuizModel quizModel) async {
    final serverTimestamp = FieldValue.serverTimestamp();
    return await _quizzesCollection.document(quizModel.id).setData({
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "totalPoints": quizModel.totalPoints,
      "lastUpdated": serverTimestamp,
    });
  }
}
