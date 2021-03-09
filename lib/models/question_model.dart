import 'package:flutter/material.dart';
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
  String imageUrl;
  String answer;
  String category;
  String difficulty;
  double points;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;
  // relational
  List<int> rounds;
  List<RoundModel> roundModels;
  UserModel user;

  QuestionModel({
    @required this.id,
    @required this.questionType,
    @required this.question,
    @required this.answer,
    @required this.category,
    @required this.points,
    this.imageUrl,
    this.difficulty,
    this.isPublished,
  });

  QuestionModel.fromJson(json) {
    this.id = json['id'];
    this.lastUpdated = DateTime.parse(json['lastUpdated']);
    this.createdAt = DateTime.parse(json['createdAt']);
    this.questionType = json['questionType'];
    this.question = json['question'];
    this.imageUrl = json['imageUrl'];
    this.answer = json['answer'];
    this.category = json['category'];
    this.difficulty = json['difficulty'];
    this.points = json['points'].toDouble();
    this.isPublished = json['isPublished'];
  }

  static List<QuestionModel> listFromJson(List<dynamic> rawQuestions) {
    List<QuestionModel> formattedQuestions = [];
    if (rawQuestions.length > 0) {
      formattedQuestions = rawQuestions.map((q) => QuestionModel.fromJson(q)).toList();
    }
    return formattedQuestions;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "questionType": questionType,
        "answer": answer,
        "imageUrl": imageUrl,
        "category": category,
        "difficulty": difficulty,
        "points": points,
        "isPublished": isPublished ?? false,
      };

  QuestionModel.newQuestion() {
    this.points = 1;
    this.questionType = "STANDARD";
    this.category = acceptedCategories[0];
  }
}
