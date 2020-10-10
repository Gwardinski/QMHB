import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';

class QuizCollectionService {
  final CollectionReference _quizzesCollection = FirebaseFirestore.instance.collection('quizzes');

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
      return snapshot.docs.map((doc) => QuizModel.fromFirebase(doc)).toList();
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
      return snapshot.docs.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<QuizModel>> getRecentQuizStream() {
    return _quizzesCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Stream<QuizModel> getQuizById(String id) {
    return _quizzesCollection.where("id", isEqualTo: id).snapshots().map((snapshot) {
      return QuizModel.fromFirebase(snapshot.docs.single);
    });
  }

  Stream<List<QuizModel>> getQuizzesByIds(List<String> ids) {
    return _quizzesCollection.where("id", whereIn: ids).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addQuizToFirebaseCollection(QuizModel quizModel, String uid) async {
    final serverTimestamp = Timestamp.now().toDate();
    final newDocId = _quizzesCollection.doc().id;
    await _quizzesCollection.doc(newDocId).set({
      "id": newDocId,
      "uid": uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "imageURL": quizModel.imageURL,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editQuizOnFirebaseCollection(QuizModel quizModel) async {
    final serverTimestamp = Timestamp.now().toDate();
    return await _quizzesCollection.doc(quizModel.id).set({
      "id": quizModel.id,
      "uid": quizModel.uid,
      "title": quizModel.title,
      "description": quizModel.description,
      "imageURL": quizModel.imageURL,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "createdAt": quizModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteQuizOnFirebaseCollection(String id) async {
    await _quizzesCollection.doc(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }

  Future<void> addRoundToQuiz(QuizModel quizModel, RoundModel roundModel) async {
    final serverTimestamp = Timestamp.now().toDate();
    final ids = quizModel.roundIds;
    ids.add(roundModel.id);
    try {
      return await _quizzesCollection.doc(quizModel.id).set(
        {
          "roundIds": ids,
          "lastUpdated": serverTimestamp,
        },
        SetOptions(
          merge: true,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeRoundFromQuiz(QuizModel quizModel, RoundModel roundModel) async {
    final serverTimestamp = Timestamp.now().toDate();
    final ids = quizModel.roundIds;
    ids.remove(roundModel.id);
    try {
      return await _quizzesCollection.doc(quizModel.id).set(
        {
          "roundIds": ids,
          "lastUpdated": serverTimestamp,
        },
        SetOptions(
          merge: true,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
