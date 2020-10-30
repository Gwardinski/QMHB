import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionCollectionService {
  // DB
  final CollectionReference _questionsCollection = FirebaseFirestore.instance.collection(
    'questions',
  );

  // GET SINGLE
  Stream<QuestionModel> streamQuestionById({
    @required String id,
  }) {
    return _questionsCollection.where("id", isEqualTo: id).snapshots().map((snapshot) {
      return QuestionModel.fromFirebase(snapshot.docs.single);
    });
  }

  // GET MANY
  Stream<List<QuestionModel>> streamQuestionsByIds({
    @required List<String> ids,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _questionsCollection
        .where("id", whereIn: ids)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  // POST
  Future<String> addQuestionToFirebaseCollection(
    QuestionModel questionModel,
    String uid,
  ) async {
    final newDocId = _questionsCollection.doc().id;
    final question = questionModel.toFirebase(
      questionModel: questionModel,
      uid: uid,
      docId: newDocId,
      lastUpdated: Timestamp.now().toDate(),
    );
    await _questionsCollection.doc(newDocId).set(question);
    return newDocId;
  }

  // PUT
  Future<void> editQuestionOnFirebaseCollection(
    QuestionModel questionModel,
  ) async {
    final question = questionModel.toFirebase(
      questionModel: questionModel,
      uid: questionModel.uid,
      docId: questionModel.id,
      lastUpdated: Timestamp.now().toDate(),
    );
    return await _questionsCollection.doc(questionModel.id).set(question);
  }

  // DELETE
  Future<void> deleteQuestionOnFirebaseCollection(String id) async {
    await _questionsCollection.doc(id).delete();
    // remove from all rounds where used
    // remove from user model
  }
}
