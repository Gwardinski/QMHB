import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';

class RoundCollectionService {
  // DB
  final CollectionReference _roundsCollection = FirebaseFirestore.instance.collection(
    'rounds',
  );

  // GET SINGLE
  Stream<RoundModel> streamRoundById({
    @required String id,
  }) {
    return _roundsCollection.where("id", isEqualTo: id).snapshots().map((snapshot) {
      return RoundModel.fromFirebase(snapshot.docs.single);
    });
  }

  // GET MANY
  Stream<List<RoundModel>> streamRoundsByIds({
    @required List<String> ids,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _roundsCollection
        .where("id", whereIn: ids)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  // POST
  Future<String> addRoundToFirebaseCollection(
    RoundModel roundModel,
    String uid,
  ) async {
    final newDocId = _roundsCollection.doc().id;
    final round = roundModel.toFirebase(
      roundModel: roundModel,
      uid: uid,
      docId: newDocId,
      lastUpdated: Timestamp.now().toDate(),
    );
    await _roundsCollection.doc(newDocId).set(round);
    return newDocId;
  }

  // PUT
  Future<void> editRoundOnFirebaseCollection(
    RoundModel roundModel,
  ) async {
    final round = roundModel.toFirebase(
      roundModel: roundModel,
      uid: roundModel.uid,
      docId: roundModel.id,
      lastUpdated: Timestamp.now().toDate(),
    );
    return await _roundsCollection.doc(roundModel.id).set(round);
  }

  Future<void> addQuestionToRound(
    RoundModel roundModel,
    QuestionModel question,
  ) async {
    final ids = roundModel.questionIds;
    ids.add(question.id);
    editRoundOnFirebaseCollection(roundModel);
  }

  Future<void> removeQuestionFromRound(
    RoundModel roundModel,
    QuestionModel question,
  ) async {
    final ids = roundModel.questionIds;
    ids.remove(question.id);
    editRoundOnFirebaseCollection(roundModel);
  }

  // DELETE
  Future<void> deleteRoundOnFirebaseCollection(
    String id,
  ) async {
    await _roundsCollection.doc(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }
}
