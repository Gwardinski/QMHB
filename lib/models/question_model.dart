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
