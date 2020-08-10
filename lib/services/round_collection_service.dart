import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/round_model.dart';

class RoundCollectionService {
  // DB collections
  final CollectionReference _roundsCollection = Firestore.instance.collection('rounds');

  // TODO handle this in single request
  Future<List<RoundModel>> getRoundsByIds(List<String> roundIds) async {
    List<RoundModel> rounds = [];
    for (var id in roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      try {
        RoundModel round = RoundModel.fromFirebase(fbround, id);
        rounds.add(round);
      } catch (e) {
        print("failed to find round with ID of $id");
      }
    }
    return rounds;
  }

  // Rounds

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
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "totalPoints": roundModel.totalPoints,
      "lastUpdated": serverTimestamp,
    });
  }
}
