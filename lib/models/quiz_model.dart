import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class QuizModel {
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
  List<int> rounds;
  List<RoundModel> roundModels;
  int user;
  UserModel userModel;

  QuizModel({
    @required this.id,
    @required this.title,
    @required this.isPublished,
    this.description,
    this.imageUrl,
    this.totalPoints,
    this.tags,
    this.rounds,
    @required this.user,
  });

  QuizModel.fromJson(json) {
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
    this.rounds = [];
    if (json['rounds'] != null) {
      json['rounds'].forEach((r) {
        this.rounds.add(r);
      });
    }
  }

  static List<QuizModel> listFromJson(List<dynamic> rawQuizzes) {
    List<QuizModel> formattedQuizzes = [];
    if (rawQuizzes.length > 0) {
      formattedQuizzes = rawQuizzes.map((q) => QuizModel.fromJson(q)).toList();
    }
    return formattedQuizzes;
  }

  // user, isPublished, totalPoints & datetimes can not be amended
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "tags": tags ?? [],
        "rounds": rounds ?? [],
      };

  QuizModel.newQuiz();
}
