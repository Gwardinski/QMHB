import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';

class QuizCollectionService {
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');

  Stream<List<QuizModel>> getQuizzesCreatedByUser({
    String userId,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _quizzesCollection
        .where("uid", isEqualTo: userId)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuizModel>> getQuizzesSavedByUser({
    List<String> savedIds,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _quizzesCollection
        // where id is equal to one of savedIds
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuizModel>> getRecentQuizStream() {
    return _quizzesCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuizModel>> getQuizzesByIds(List<String> ids) {
    return _quizzesCollection.where("id", whereIn: ids).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addQuizToFirebaseCollection(QuizModel quizModel, String uid) async {
    final serverTimestamp = Timestamp.now().toDate();
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
    final serverTimestamp = Timestamp.now().toDate();
    return await _quizzesCollection.document(quizModel.id).setData({
      "id": quizModel.id,
      "uid": quizModel.uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "createdAt": quizModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteQuizOnFirebaseCollection(String id) async {
    await _quizzesCollection.document(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }

  Future<void> addRoundToQuiz(QuizModel quizModel, RoundModel round) async {
    final serverTimestamp = Timestamp.now().toDate();
    return await _quizzesCollection.document(quizModel.id).setData({
      "id": quizModel.id,
      "uid": quizModel.uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "questionIds": quizModel.questionIds,
      "roundIds": List.from(quizModel.roundIds)..addAll([round.id]),
      "isPublished": false,
      "createdAt": quizModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> removeRoundFromQuiz(QuizModel quizModel, RoundModel round) async {
    final serverTimestamp = Timestamp.now().toDate();
    final ids = quizModel.roundIds;
    ids.remove(round.id);
    return await _quizzesCollection.document(quizModel.id).setData({
      "id": quizModel.id,
      "uid": quizModel.uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "questionIds": quizModel.questionIds,
      "roundIds": ids,
      "isPublished": false,
      "createdAt": quizModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }
}
