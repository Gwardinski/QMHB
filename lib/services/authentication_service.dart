import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  Future<UserModel> autoSignIn() async {
    try {
      FirebaseUser fbUser = await _auth.currentUser();
      DocumentSnapshot firebaseData = await _databaseService.getUserFromUsersCollectionUsingUID(
        fbUser.uid,
      );
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
      _databaseService.updateUserDataOnFirebase(newUser);
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
      DocumentSnapshot firebaseData = await _databaseService.getUserFromUsersCollectionUsingUID(
        fbUser.uid,
      );
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
