import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/user_model.dart';

class UserCollectionService {
  // DB collections
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  // Log in user
  Future<DocumentSnapshot> getUserFromUsersCollectionUsingUID(uid) async {
    return await _usersCollection.doc(uid).get();
  }

  // stream user changes - called on base widget UserListener
  Stream<UserModel> getUserStream(id) {
    return _usersCollection.doc(id).snapshots().map((user) {
      return UserModel.fromFirebase(user);
    });
  }

  // Update user on Firebase
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
