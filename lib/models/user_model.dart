import 'package:flutter/material.dart';

class UserModel {
  String email;
  String displayName;
  String authToken;
  int totalQuestions;
  int totalRounds;
  int totalQuizzes;

  UserModel({
    @required this.email,
    @required this.displayName,
    @required this.authToken,
  });

  UserModel.fromJson(json) {
    email = json['email'];
    displayName = json['displayName'];
    authToken = json['token'];
    totalQuestions = json['totalQuestions'];
    totalRounds = json['totalRounds'];
    totalQuizzes = json['totalQuizzes'];
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': authToken,
        'displayName': displayName,
        'totalQuestions': totalQuestions ?? '',
        'totalRounds': totalRounds ?? '',
        'totalQuizzes': totalQuizzes ?? '',
      };
}
