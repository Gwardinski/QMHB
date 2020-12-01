import 'dart:convert';

import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class QuizModel {
  int id;
  String title;
  String description;
  String imageURL;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;
  // relational
  int noOfRounds;
  int noOfQuestions;
  double totalPoints;
  List<RoundModel> rounds;
  UserModel user;

  QuizModel({
    this.id,
    this.title,
    this.description,
    this.imageURL,
    this.totalPoints,
    this.isPublished,
  });

  QuizModel.fromJSON(json) {
    this.id = json['id'];
    this.lastUpdated = json['lastUpdated'];
    this.createdAt = json['createdAt'];
    this.title = json['title'];
    this.totalPoints = json['totalPoints'] ?? 0;
    this.description = json['description'];
    this.imageURL = json['imageURL'];
    this.isPublished = json['isPublished'] ?? false;
  }

  QuizModel.fromDto(json) {
    this.id = json['id'];
    // this.lastUpdated = json['lastUpdated'].toDate();
    // this.createdAt = json['createdAt'].toDate();
    this.title = json['title'];
    this.totalPoints = json['totalPoints'].toDouble();
    this.description = json['description'];
    this.imageURL = json['imageURL'];
    this.isPublished = json['isPublished'] ?? false;
  }

  static List<QuizModel> listFromDtos(List<dynamic> rawQuizzes) {
    List<QuizModel> formattedQuizzes = List<QuizModel>();
    if (rawQuizzes.length > 0) {
      formattedQuizzes = rawQuizzes.map((q) => QuizModel.fromDto(q)).toList();
    }
    return formattedQuizzes;
  }

  static toDtoAdd(
    QuizModel quizModel,
    int initialRoundId,
  ) {
    return jsonEncode({
      "title": quizModel.title,
      "description": quizModel.description,
      "imageURL": quizModel.imageURL,
      "initialRoundId": initialRoundId ?? 0,
    });
  }

  static toDtoEdit(
    QuizModel quizModel,
  ) {
    return jsonEncode({
      "id": quizModel.id,
      "title": quizModel.title,
      "description": quizModel.description,
      "imageURL": quizModel.imageURL,
    });
  }

  QuizModel.newQuiz();
}
