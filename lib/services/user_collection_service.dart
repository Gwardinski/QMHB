import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/user_model.dart';

class UserCollectionService {
  // DB collections
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Stream<UserModel> getUserStream(uid) {
    print("getUserStream");
    return _usersCollection.doc(uid).snapshots().map((user) {
      return UserModel.fromFirebase(user);
    });
  }

  Future<DocumentSnapshot> getUserFromUsersCollectionUsingUID(uid) async {
    try {
      return await _usersCollection.doc(uid).get();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future updateUserDataOnFirebase(UserModel userModel) async {
    return await _usersCollection.doc(userModel.uid).set({
      "uid": userModel.uid,
      "displayName": userModel.displayName,
      "email": userModel.email,
      "quizIds": userModel.quizIds,
      "roundIds": userModel.roundIds,
      "questionIds": userModel.questionIds,
      "lastUpdated": Timestamp.now().toDate(),
      "createdAt": userModel.createdAt,
    });
  }
}
