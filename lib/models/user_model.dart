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
  Timestamp lastUpdated;
  Timestamp createAt;

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
    this.createAt,
  });

  UserModel.registerNewUser({
    @required this.uid,
    @required this.email,
    @required this.displayName,
  }) {
    lastUpdated = Timestamp.now();
    createAt = Timestamp.now();
    quizIds = List<String>();
    roundIds = List<String>();
    questionIds = List<String>();
    savedQuizIds = List<String>();
    savedRoundIds = List<String>();
    savedQuestionIds = List<String>();
  }

  UserModel.fromFirebase(data) {
    uid = data['uid'];
    email = data['email'];
    displayName = data['displayName'];
    lastUpdated = data['lastUpdated'];
    createAt = data['createAt'];
    quizIds = List<String>();
    if (data['quizIds'] != null) {
      data['quizIds'].forEach((id) {
        quizIds.add(id);
      });
    }
    roundIds = List<String>();
    if (data['roundIds'] != null) {
      data['roundIds'].forEach((id) {
        roundIds.add(id);
      });
    }
    questionIds = List<String>();
    if (data['questionIds'] != null) {
      data['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
    savedQuizIds = List<String>();
    if (data['savedQuizIds'] != null) {
      data['savedQuizIds'].forEach((id) {
        savedQuizIds.add(id);
      });
    }
    savedRoundIds = List<String>();
    if (data['savedRoundIds'] != null) {
      data['savedRoundIds'].forEach((id) {
        savedRoundIds.add(id);
      });
    }
    savedQuestionIds = List<String>();
    if (data['savedQuestionIds'] != null) {
      data['savedQuestionIds'].forEach((id) {
        savedQuestionIds.add(id);
      });
    }
  }
}
