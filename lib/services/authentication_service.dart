import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/user_collection_service.dart';

class AuthenticationService {
  final UserDataStateModel userDataStateModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserCollectionService _userService = UserCollectionService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthenticationService({
    this.userDataStateModel,
  }) {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        _updateUserState(user);
      } else {
        userDataStateModel.removeCurrentUser();
      }
    });
  }

  _updateUserState(FirebaseUser user) async {
    final userDoc = await _userService.getUserFromUsersCollectionUsingUID(
      user.uid,
    );
    final userModel = UserModel.fromFirebase(userDoc);
    userDataStateModel.updateCurrentUser(userModel);
  }

  Future<void> googleSignIn() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      UserModel newUser = UserModel.registerNewUser(
        email: user.email,
        displayName: user.displayName,
        uid: user.uid,
      );
      _userService.updateUserDataOnFirebase(newUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> registerWithEmailAndPassword({
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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> signInWithEmailAndPassword({
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
