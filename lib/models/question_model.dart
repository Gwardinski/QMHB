import 'dart:convert';

import 'package:qmhb/models/category_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

enum QuestionType {
  STANDARD,
  MUSIC,
  MULTIPLECHOICE,
}

class QuestionModel {
  int id;
  String questionType;
  String question;
  String imageURL;
  String answer;
  String category;
  String difficulty;
  double points;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;
  // relational
  List<RoundModel> rounds;
  UserModel user;

  QuestionModel({
    this.id,
    this.questionType,
    this.question,
    this.imageURL,
    this.answer,
    this.category,
    this.difficulty,
    this.points,
    this.isPublished,
  });

  QuestionModel.fromDto(json) {
    this.id = json['id'];
    // this.lastUpdated = json['lastUpdated'].toDate();
    // this.createdAt = json['createdAt'].toDate();
    this.questionType = json['questionType'];
    this.question = json['question'];
    this.imageURL = json['imageURL'];
    this.answer = json['answer'];
    this.category = json['category'];
    this.difficulty = json['difficulty'];
    this.points = json['points'].toDouble();
    this.isPublished = json['isPublished'];
  }

  static List<QuestionModel> listFromDtos(List<dynamic> rawQuestions) {
    List<QuestionModel> formattedQuestions = List<QuestionModel>();
    if (rawQuestions.length > 0) {
      formattedQuestions = rawQuestions.map((q) => QuestionModel.fromDto(q)).toList();
    }
    return formattedQuestions;
  }

  toDto({
    QuestionModel questionModel,
  }) {
    return {
      "id": questionModel.id,
      "question": questionModel.question,
      "questionType": questionModel.questionType,
      "answer": questionModel.answer,
      "imageURL": questionModel.imageURL,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": questionModel.isPublished,
    };
  }

  static toDtoAdd(
    QuestionModel questionModel,
    int parentRoundId,
  ) {
    return jsonEncode({
      "question": questionModel.question,
      "questionType": questionModel.questionType,
      "answer": questionModel.answer,
      "imageURL": questionModel.imageURL,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "parentRoundId": parentRoundId ?? 0,
    });
  }

  static toDtoEdit(QuestionModel questionModel) {
    return jsonEncode({
      "id": questionModel.id,
      "question": questionModel.question,
      "questionType": questionModel.questionType,
      "answer": questionModel.answer,
      "imageURL": questionModel.imageURL,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
    });
  }

  QuestionModel.newQuestion() {
    this.points = 1;
    this.questionType = "STANDARD";
    this.category = acceptedCategories[0];
  }
}
