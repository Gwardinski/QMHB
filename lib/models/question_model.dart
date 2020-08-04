import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String uid;
  String userId;
  String question;
  String answer;
  String category;
  String difficulty;
  double points;
  bool isPublished;

  QuestionModel({
    this.uid,
    this.userId,
    this.question,
    this.answer,
    this.category,
    this.difficulty,
    this.points,
    this.isPublished,
  });

  QuestionModel.fromJSON(json) {
    this.userId = json['userId'] ?? '';
    this.question = json['question'] ?? '';
    this.answer = json['answer'] ?? '';
    this.category = json['category'] ?? '';
    this.difficulty = json['difficulty'] ?? '';
    this.points = json['points'] ?? 1;
    this.isPublished = json['isPublished'] ?? false;
  }

  QuestionModel.fromFirebase(DocumentSnapshot document, String id) {
    this.uid = id;
    this.userId = document.data['userId'] ?? '';
    this.question = document.data['question'] ?? '';
    this.answer = document.data['answer'] ?? '';
    this.category = document.data['category'] ?? '';
    this.difficulty = document.data['difficulty'] ?? '';
    this.points = document.data['points'] ?? 1;
    this.isPublished = document.data['isPublished'] ?? false;
  }
}
