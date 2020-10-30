import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';

class QuizCollectionService {
  // DB
  final CollectionReference _quizzesCollection = FirebaseFirestore.instance.collection(
    'quizzes',
  );

  // GET SINGLE
  Stream<QuizModel> streamQuizById({
    @required String id,
  }) {
    return _quizzesCollection.where("id", isEqualTo: id).snapshots().map((snapshot) {
      return QuizModel.fromFirebase(snapshot.docs.single);
    });
  }

  // GET MANY
  Stream<List<QuizModel>> streamQuizzesByIds({
    @required List<String> ids,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _quizzesCollection
        .where("id", whereIn: ids)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => QuizModel.fromFirebase(doc)).toList();
    });
  }

  // POST
  Future<String> addQuizToFirebaseCollection(
    QuizModel quizModel,
    String uid,
  ) async {
    final newDocId = _quizzesCollection.doc().id;
    final quiz = quizModel.toFirebase(
      quizModel: quizModel,
      uid: uid,
      docId: newDocId,
      lastUpdated: Timestamp.now().toDate(),
    );
    await _quizzesCollection.doc(newDocId).set(quiz);
    return newDocId;
  }

  // PUT
  Future<void> editQuizOnFirebaseCollection(
    QuizModel quizModel,
  ) async {
    final quiz = quizModel.toFirebase(
      quizModel: quizModel,
      uid: quizModel.uid,
      docId: quizModel.id,
      lastUpdated: Timestamp.now().toDate(),
    );
    return await _quizzesCollection.doc(quizModel.id).set(quiz);
  }

  Future<void> addRoundToQuiz(
    QuizModel quizModel,
    RoundModel roundModel,
  ) async {
    final ids = quizModel.roundIds;
    ids.add(roundModel.id);
    editQuizOnFirebaseCollection(quizModel);
  }

  Future<void> removeRoundFromQuiz(
    QuizModel quizModel,
    RoundModel roundModel,
  ) async {
    final ids = quizModel.roundIds;
    ids.remove(roundModel.id);
    editQuizOnFirebaseCollection(quizModel);
  }

  // DELETE
  Future<void> deleteQuizOnFirebaseCollection(
    String id,
  ) async {
    await _quizzesCollection.doc(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }
}
