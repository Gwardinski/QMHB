import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/user_collection_service.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserCollectionService _userService = UserCollectionService();

  Future<UserModel> autoSignIn() async {
    try {
      FirebaseUser fbUser = await _auth.currentUser();
      print(fbUser);
      DocumentSnapshot firebaseData = await _userService.getUserFromUsersCollectionUsingUID(
        fbUser.uid,
      );
      print(firebaseData);
      return UserModel.fromFirebase(firebaseData);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel> registerWithEmailAndPassword({
    String email,
    String password,
    String displayName,
  }) async {
    try {
      FirebaseUser fbUser = await _firebaseCreateUserWithEmailAndPassword(email, password);
      UserModel newUser = UserModel.registerNewUser(
        email: email,
        displayName: displayName,
        uid: fbUser.uid,
      );
      _userService.updateUserDataOnFirebase(newUser);
      return newUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModel> signInWithEmailAndPassword({
    String email,
    String password,
  }) async {
    try {
      FirebaseUser fbUser = await _firebaseGetUserFromEmailAndPassword(email, password);
      DocumentSnapshot firebaseData = await _userService.getUserFromUsersCollectionUsingUID(
        fbUser.uid,
      );
      if (firebaseData.data == null) {
        UserModel newUser = UserModel.registerNewUser(
          email: email,
          displayName: null,
          uid: fbUser.uid,
        );
        _userService.updateUserDataOnFirebase(newUser);
      }
      return UserModel.fromFirebase(firebaseData);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<FirebaseUser> _firebaseCreateUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    AuthResult res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<FirebaseUser> _firebaseGetUserFromEmailAndPassword(
    String email,
    String password,
  ) async {
    AuthResult res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }
}
