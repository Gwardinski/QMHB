import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  Future<UserModel> registerWithEmailAndPassword({
    String email,
    String password,
    String displayName,
  }) async {
    try {
      FirebaseUser fbUser = await _firebaseCreateUserWithEmailAndPassword(email, password);
      // RoundModel newRound1 = RoundModel(
      //   title: "$displayName Round 1",
      //   description: "Your first round!",
      //   questionIds: ["8iRQVLThHhXeqllTGiBD", "BwovO5vIQ4PPnnxVwQ2E"],
      //   totalPoints: 2.0,
      //   isPublished: false,
      // );
      // RoundModel newRound2 = RoundModel(
      //   title: "$displayName Round 2",
      //   description: "Your second round!",
      //   questionIds: [],
      //   totalPoints: 0.0,
      //   isPublished: false,
      // );
      // QuizModel newQuiz = QuizModel(
      //   title: "$displayName Quiz 1",
      //   description: "Your first quiz!",
      //   totalPoints: 0.0,
      //   isPublished: false,
      // );
      print(fbUser);
      UserModel newUser = UserModel.registerNewUser(
        email: email,
        displayName: displayName,
        uid: fbUser.uid,
      );
      // UserModel registeredUser = await _databaseService.updateUserDataOnFirebase(newUser);
      // await _databaseService.addRoundToFirebase(newRound1, registeredUser);
      // await _databaseService.addRoundToFirebase(newRound2, registeredUser);
      // await _databaseService.addQuizToFirebase(newQuiz, registeredUser);
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
