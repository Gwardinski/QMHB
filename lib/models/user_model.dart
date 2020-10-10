import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String email;
  String displayName;
  List<String> quizIds;
  List<String> roundIds;
  List<String> questionIds;
  List<String> savedQuestionIds;
  List<String> savedRoundIds;
  List<String> savedQuizIds;
  DateTime lastUpdated;
  DateTime createdAt;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.displayName,
    this.quizIds,
    this.roundIds,
    this.questionIds,
    this.savedQuizIds,
    this.savedRoundIds,
    this.savedQuestionIds,
    this.lastUpdated,
    this.createdAt,
  });

  UserModel.registerNewUser({
    @required this.uid,
    @required this.email,
    @required this.displayName,
  }) {
    lastUpdated = Timestamp.now().toDate();
    createdAt = Timestamp.now().toDate();
    quizIds = List<String>();
    roundIds = List<String>();
    questionIds = List<String>();
    savedQuizIds = List<String>();
    savedRoundIds = List<String>();
    savedQuestionIds = List<String>();
  }

  UserModel.fromFirebase(DocumentSnapshot document) {
    print(document);
    print(document.data()['lastUpdated']);
    print(document.data()['createdAt']);
    uid = document.data()['uid'];
    email = document.data()['email'];
    displayName = document.data()['displayName'];
    lastUpdated = document.data()['lastUpdated'].toDate();
    createdAt = document.data()['createdAt']?.toDate();
    quizIds = List<String>();
    if (document.data()['quizIds'] != null) {
      document.data()['quizIds'].forEach((id) {
        quizIds.add(id);
      });
    }
    roundIds = List<String>();
    if (document.data()['roundIds'] != null) {
      document.data()['roundIds'].forEach((id) {
        roundIds.add(id);
      });
    }
    questionIds = List<String>();
    if (document.data()['questionIds'] != null) {
      document.data()['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
    savedQuizIds = List<String>();
    if (document.data()['savedQuizIds'] != null) {
      document.data()['savedQuizIds'].forEach((id) {
        savedQuizIds.add(id);
      });
    }
    savedRoundIds = List<String>();
    if (document.data()['savedRoundIds'] != null) {
      document.data()['savedRoundIds'].forEach((id) {
        savedRoundIds.add(id);
      });
    }
    savedQuestionIds = List<String>();
    if (document.data()['savedQuestionIds'] != null) {
      document.data()['savedQuestionIds'].forEach((id) {
        savedQuestionIds.add(id);
      });
    }
    print(2);
  }
}
