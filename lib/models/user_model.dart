import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String email;
  String displayName;
  List<String> quizIds;
  List<String> roundIds;
  List<String> questionIds;
  String lastUpdated;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.displayName,
    this.quizIds,
    this.roundIds,
    this.questionIds,
    this.lastUpdated,
  });

  UserModel.registerNewUser({
    @required this.uid,
    @required this.email,
    @required this.displayName,
  }) {
    lastUpdated = DateTime.now().toString();
    quizIds = List<String>();
    roundIds = List<String>();
    questionIds = List<String>();
  }

  UserModel.fromFirebase(data) {
    uid = data['uid'];
    email = data['email'];
    displayName = data['displayName'];
    lastUpdated = data['lastUpdated'];
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
  }
}
