import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/category_model.dart';

enum QuestionType {
  STANDARD,
  MUSIC,
  MULTIPLECHOICE,
}

class QuestionModel {
  String id;
  String uid;
  String question;
  String answer;
  String category;
  String difficulty;
  double points;
  bool isPublished;
  Timestamp lastUpdated;
  Timestamp createAt;

  QuestionModel({
    this.id,
    this.uid,
    this.question,
    this.answer,
    this.category,
    this.difficulty,
    this.points,
    this.isPublished,
  });

  QuestionModel.fromJSON(json) {
    this.id = json['id'] ?? '';
    this.uid = json['uid'] ?? '';
    this.lastUpdated = json['lastUpdated'];
    this.createAt = json['createAt'];
    this.question = json['question'] ?? '';
    this.answer = json['answer'] ?? '';
    this.category = json['category'] ?? '';
    this.difficulty = json['difficulty'] ?? '';
    this.points = json['points'] ?? 1;
    this.isPublished = json['isPublished'] ?? false;
  }

  QuestionModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data['id'] ?? '';
    this.uid = document.data['uid'] ?? '';
    this.lastUpdated = document.data['lastUpdated'];
    this.createAt = document.data['createAt'];
    this.question = document.data['question'] ?? '';
    this.answer = document.data['answer'] ?? '';
    this.category = document.data['category'] ?? '';
    this.difficulty = document.data['difficulty'] ?? '';
    this.points = document.data['points'] ?? 1;
    this.isPublished = document.data['isPublished'] ?? false;
  }

  QuestionModel.newQuestion() {
    this.points = 1;
    this.category = acceptedCategories[0];
  }
}
