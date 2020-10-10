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

  QuestionModel({
    this.id,
    this.uid,
    this.questionType,
    this.question,
    this.imageURL,
    this.answer,
    this.category,
    this.difficulty,
    this.points,
    this.isPublished,
  });

  QuestionModel.fromJSON(json) {
    this.id = json['id'];
    this.uid = json['uid'];
    this.lastUpdated = json['lastUpdated'];
    this.createdAt = json['createdAt'];
    this.questionType = json['questionType'];
    this.question = json['question'];
    this.imageURL = json['imageURL'];
    this.answer = json['answer'];
    this.category = json['category'];
    this.difficulty = json['difficulty'];
    this.points = json['points'] ?? 1;
    this.isPublished = json['isPublished'] ?? false;
  }

  QuestionModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data()['id'];
    this.uid = document.data()['uid'];
    this.lastUpdated = document.data()['lastUpdated'].toDate();
    this.createdAt = document.data()['createdAt'].toDate();
    this.questionType = document.data()['questionType'];
    this.question = document.data()['question'];
    this.imageURL = document.data()['imageURL'];
    this.answer = document.data()['answer'];
    this.category = document.data()['category'];
    this.difficulty = document.data()['difficulty'];
    this.points = document.data()['points'].toDouble() ?? 1.0;
    this.isPublished = document.data()['isPublished'] ?? false;
  }

  QuestionModel.newQuestion() {
    this.points = 1;
    this.category = acceptedCategories[0];
  }
}
