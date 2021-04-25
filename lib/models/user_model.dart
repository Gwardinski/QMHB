import 'package:flutter/material.dart';

class UserModel {
  int id;
  String email;
  String displayName;
  String authToken;
  int totalQuestions;
  int totalRounds;
  int totalQuizzes;
  List<int> savedQuestions;
  List<int> savedRounds;
  List<int> savedQuizzes;

  UserModel({
    @required this.email,
    @required this.displayName,
    @required this.authToken,
  });

  UserModel.fromJson(json) {
    this.id = json['id'];
    this.email = json['email'];
    this.displayName = json['displayName'];
    this.authToken = json['token'];
    this.totalQuestions = json['totalQuestions'];
    this.totalRounds = json['totalRounds'];
    this.totalQuizzes = json['totalQuizzes'];
    this.savedQuestions = [];
    if (json['savedQuestions'] != null) {
      json['savedQuestions'].forEach((r) {
        this.savedQuestions.add(r);
      });
    }
    this.savedRounds = [];
    if (json['savedRounds'] != null) {
      json['savedRounds'].forEach((r) {
        this.savedRounds.add(r);
      });
    }
    this.savedQuizzes = [];
    if (json['savedQuizzes'] != null) {
      json['savedQuizzes'].forEach((r) {
        this.savedQuizzes.add(r);
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'token': authToken,
        'displayName': displayName,
        'totalQuestions': totalQuestions ?? '',
        'totalRounds': totalRounds ?? '',
        'totalQuizzes': totalQuizzes ?? '',
        "savedQuestions": savedQuestions ?? [],
        "savedRounds": savedRounds ?? [],
        "savedQuizzes": savedQuizzes ?? [],
      };
}
