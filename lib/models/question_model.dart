import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  String id;
  String question;
  // TODO convert to array of AnswerModel
  String answer;
  String category;
  String difficulty;
  double points;
  // UserModel user;
  // bool isPublished;

  QuestionModel({
    this.id,
    this.question,
    this.answer,
    this.category,
    this.difficulty,
    this.points,
  });

  QuestionModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data['id'] ?? '';
    this.question = document.data['question'] ?? '';
    this.answer = document.data['answer'] ?? '';
    this.category = document.data['category'] ?? '';
    this.difficulty = document.data['difficulty'] ?? '';
    this.points = document.data['points'] ?? 1;
  }
}
