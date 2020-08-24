import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionCollectionService {
  // DB collections
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  Stream<List<QuestionModel>> getQuestionsCreatedByUser({
    String userId,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _questionsCollection
        .where("uid", isEqualTo: userId)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuestionModel>> getQuestionsSavedByUser({
    List<String> savedIds,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _questionsCollection
        // where id is equal to one of savedIds
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuestionModel>> getRecentQuestionStream() {
    return _questionsCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuestionModel>> getQuestionsByIds(List<String> ids) {
    return _questionsCollection.where("id", whereIn: ids).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addQuestionToFirebaseCollection(
    QuestionModel questionModel,
    String uid,
  ) async {
    final serverTimestamp = Timestamp.now();
    final newDocId = _questionsCollection.document().documentID;
    await _questionsCollection.document(newDocId).setData({
      "id": newDocId,
      "uid": uid,
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editQuestionOnFirebaseCollection(
    QuestionModel questionModel,
  ) async {
    final serverTimestamp = Timestamp.now();
    return await _questionsCollection.document(questionModel.id).setData({
      "id": questionModel.id,
      "uid": questionModel.uid,
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": questionModel.isPublished,
      "createdAt": questionModel.createAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteQuestionOnFirebaseCollection(String id) async {
    await _questionsCollection.document(id).delete();
    // remove from all rounds where used
    // remove from user model
  }
}
