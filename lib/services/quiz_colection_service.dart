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
        QuizModel quiz = QuizModel.fromFirebase(fbquiz);
        quizzes.add(quiz);
      } catch (e) {
        print("failed to find quiz with ID of $id");
      }
    }
    return quizzes;
  }

  Stream<List<QuizModel>> getRecentQuizStream() {
    return _quizzesCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addQuizToFirebaseCollection(QuizModel quizModel, String uid) async {
    final serverTimestamp = Timestamp.now();
    final newDocId = _quizzesCollection.document().documentID;
    await _quizzesCollection.document(newDocId).setData({
      "id": newDocId,
      "uid": uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editQuizOnFirebaseCollection(QuizModel quizModel) async {
    final serverTimestamp = Timestamp.now();
    return await _quizzesCollection.document(quizModel.id).setData({
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "totalPoints": quizModel.totalPoints,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteQuizOnFirebaseCollection(String id) async {
    await _quizzesCollection.document(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }
}
