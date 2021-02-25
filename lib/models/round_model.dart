import 'dart:convert';

import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/user_model.dart';

class RoundModel {
  int id;
  String title;
  String description;
  String imageURL;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;
  // relational
  double totalPoints;
  int noOfQuestions;
  List<QuestionModel> questions;
  UserModel user;

  RoundModel({
    this.id,
    this.title,
    this.description,
    this.imageURL,
    this.totalPoints,
    this.isPublished,
  });

  RoundModel.fromDto(json) {
    this.id = json['id'];
    // this.lastUpdated = json['lastUpdated'].toDate();
    // this.createdAt = json['createdAt'].toDate();
    this.title = json['title'];
    this.totalPoints = json['totalPoints'].toDouble();
    this.description = json['description'];
    this.imageURL = json['imageURL'];
    this.isPublished = json['isPublished'] ?? false;
  }

  static List<RoundModel> listFromDtos(List<dynamic> rawRounds) {
    List<RoundModel> formattedRounds = [];
    if (rawRounds.length > 0) {
      formattedRounds = rawRounds.map((q) => RoundModel.fromDto(q)).toList();
    }
    return formattedRounds;
  }

  static toDtoAdd(
    RoundModel roundModel,
    int initialRoundId,
    int parentQuizId,
  ) {
    return jsonEncode({
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
      "initialRoundId": initialRoundId ?? 0,
      "parentQuizId": parentQuizId ?? 0,
    });
  }

  static toDtoEdit(
    RoundModel roundModel,
  ) {
    return jsonEncode({
      "id": roundModel.id,
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
    });
  }

  RoundModel.newRound();
}
