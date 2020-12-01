import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String email;
  String displayName;
  String authToken;
  int noOfQuestions;
  int noOfRounds;
  int noOfQuizzes;
  DateTime lastUpdated;
  DateTime createdAt;

  UserModel({
    @required this.uid,
    @required this.email,
    @required this.displayName,
    @required this.authToken,
    this.lastUpdated,
    this.createdAt,
  });

  UserModel.fromDto(json) {
    uid = json['uid'];
    email = json['email'];
    displayName = json['displayName'];
    authToken = json['authToken'];
    noOfQuestions = json['noOfQuestions'];
    noOfRounds = json['noOfRounds'];
    noOfQuizzes = json['noOfQuizzes'];
    // lastUpdated = json['lastUpdated'].toDate();
    // createdAt = json['createdAt']?.toDate();
  }
}
