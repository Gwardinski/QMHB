import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class DatabaseService {
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

  addRoundToFirebase(RoundModel roundModel, UserModel userModel) async {
    DocumentReference doc = await _addRoundToFirebaseCollection(roundModel, userModel.uid);
    userModel.roundIds.add(doc.documentID);
    // await updateUserDataOnFirebase(userModel);
  }

  Future _addRoundToFirebaseCollection(RoundModel roundModel, String uid) async {
    return await _roundsCollection.add({
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "uid": uid,
    });
  }

  editRoundOnFirebase(RoundModel roundModel, UserModel userModel) async {
    await _editRoundOnFirebaseCollection(roundModel, userModel.uid);
    // await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editRoundOnFirebaseCollection(RoundModel roundModel, String uid) async {
    // TODO - wrong ID here!
    // return await _roundsCollection.document(roundModel.uid).setData({
    //   "title": roundModel.title,
    //   "description": roundModel.description,
    //   "questionIds": roundModel.questionIds,
    //   "totalPoints": roundModel.totalPoints,
    //   "isPublished": false,
    //   "uid": uid,
    // });
  }
}
