import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/round_model.dart';

class RoundCollectionService {
  // DB collections
  final CollectionReference _roundsCollection = Firestore.instance.collection('rounds');

  // Todo - add pagination
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
      return snapshot.documents.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  // Todo - add pagination
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
      return snapshot.documents.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Stream<List<RoundModel>> getRecentRoundStream() {
    return _roundsCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => RoundModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addRoundToFirebaseCollection(RoundModel roundModel, String uid) async {
    final serverTimestamp = Timestamp.now();
    final newDocId = _roundsCollection.document().documentID;
    await _roundsCollection.document(newDocId).setData({
      "id": newDocId,
      "uid": uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editRoundOnFirebaseCollection(RoundModel roundModel) async {
    final serverTimestamp = Timestamp.now();
    return await _roundsCollection.document(roundModel.id).setData({
      "id": roundModel.id,
      "uid": roundModel.uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "createdAt": roundModel.createAt,
      "lastUpdated": serverTimestamp,
    });
  }

  Future<void> deleteRoundOnFirebaseCollection(String id) async {
    await _roundsCollection.document(id).delete();
    // remove from all quizzes where used
    // remove from user model
  }
}
