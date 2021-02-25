import 'package:flutter/material.dart';

class UserModel {
  String email;
  String displayName;
  String authToken;
  int totalQuestions;
  int totalRounds;
  int totalQuizzes;
  DateTime lastUpdated;
  DateTime createdAt;

  UserModel({
    @required this.email,
    @required this.displayName,
    @required this.authToken,
    this.lastUpdated,
    this.createdAt,
  });

  UserModel.fromJson(json) {
    email = json['email'];
    displayName = json['displayName'];
    authToken = json['authToken'];
    totalQuestions = json['totalQuestions'];
    totalRounds = json['totalRounds'];
    totalQuizzes = json['totalQuizzes'];
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'authToken': authToken,
        'displayName': displayName,
        'totalQuestions': totalQuestions ?? '',
        'totalRounds': totalRounds ?? '',
        'totalQuizzes': totalQuizzes ?? '',
      };
}
