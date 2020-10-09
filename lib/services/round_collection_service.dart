import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';

class RoundCollectionService {
  final CollectionReference _roundsCollection = FirebaseFirestore.instance.collection('rounds');

  Stream<List<RoundModel>> getRoundsCreatedByUser({
    String userId,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _roundsCollection
        .where("uid", isEqualTo: userId)
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<RoundModel>> getRoundsSavedByUser({
    List<String> savedIds,
    String orderBy = "lastUpdated",
    int limit = 100,
  }) {
    return _roundsCollection
        // where id is equal to one of savedIds
        // .orderBy(orderBy)
        // .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<RoundModel>> getRecentRoundStream() {
    return _roundsCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<RoundModel>> getRoundsByIds(List<String> ids) {
    return _roundsCollection.where("id", whereIn: ids).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addRoundToFirebaseCollection(RoundModel roundModel, String uid) async {
    final serverTimestamp = Timestamp.now().toDate();
    final newDocId = _roundsCollection.doc().id;
    await _roundsCollection.doc(newDocId).set({
      "id": newDocId,
      "uid": uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editRoundOnFirebaseCollection(RoundModel roundModel) async {
    final serverTimestamp = Timestamp.now().toDate();
    return await _roundsCollection.doc(roundModel.id).set({
      "id": roundModel.id,
      "uid": roundModel.uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "createdAt": roundModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteRoundOnFirebaseCollection(String id) async {
    await _roundsCollection.doc(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }

  Future<void> addQuestionToRound(RoundModel roundModel, QuestionModel question) async {
    final serverTimestamp = Timestamp.now().toDate();
    try {
      return await _roundsCollection.doc(roundModel.id).set({
        "id": roundModel.id,
        "uid": roundModel.uid,
        "title": roundModel.title,
        "description": roundModel.description,
        "imageURL": roundModel.imageURL,
        "questionIds": List.from(roundModel.questionIds)..addAll([question.id]),
        "isPublished": false,
        "createdAt": roundModel.createdAt,
        "lastUpdated": serverTimestamp,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeQuestionToRound(RoundModel roundModel, QuestionModel question) async {
    final serverTimestamp = Timestamp.now().toDate();
    final ids = roundModel.questionIds;
    ids.remove(question.id);
    return await _roundsCollection.doc(roundModel.id).set({
      "id": roundModel.id,
      "uid": roundModel.uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
      "questionIds": ids,
      "isPublished": false,
      "createdAt": roundModel.createdAt,
      "lastUpdated": serverTimestamp,
    });
  }
}
