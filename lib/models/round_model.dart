import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/user_model.dart';

class RoundModel {
  int id;
  String title;
  String description;
  String imageUrl;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;
  // relational
  double totalPoints;
  List<String> tags;
  List<int> questions;
  List<QuestionModel> questionModels;
  int user;
  UserModel userModel;

  RoundModel({
    @required this.id,
    @required this.title,
    @required this.isPublished,
    this.description,
    this.imageUrl,
    this.totalPoints,
    this.tags,
    this.questions,
    @required this.user,
  });

  RoundModel.fromJson(json) {
    this.id = json['id'];
    this.lastUpdated = DateTime.parse(json['lastUpdated']);
    this.createdAt = DateTime.parse(json['createdAt']);
    this.title = json['title'];
    this.totalPoints = json['totalPoints'].toDouble();
    this.description = json['description'];
    this.imageUrl = json['imageUrl'];
    this.isPublished = json['isPublished'] ?? false;
    this.user = json['user'];
    this.tags = [];
    if (json['tags'] != null) {
      json['tags'].forEach((t) {
        this.tags.add(t);
      });
    }

    this.questions = [];
    if (json['questions'] != null) {
      json['questions'].forEach((q) {
        this.questions.add(q);
      });
    }
  }

  static List<RoundModel> listFromJson(List<dynamic> rawRounds) {
    List<RoundModel> formattedRounds = [];
    if (rawRounds.length > 0) {
      formattedRounds = rawRounds.map((q) => RoundModel.fromJson(q)).toList();
    }
    return formattedRounds;
  }

  // user, isPublished & datetimes can not be amended
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "totalPoints": totalPoints,
        "tags": tags,
        "questions": questions,
      };

  RoundModel.newRound();
}
