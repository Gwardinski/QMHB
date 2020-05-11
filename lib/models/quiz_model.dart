import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String uid;
  String userId;
  String title;
  String description;
  int rating;
  int difficulty;
  double totalPoints;
  bool isPublished;
  List<String> roundIds;
  List<String> questionIds;

  QuizModel({
    this.uid,
    this.userId,
    this.title,
    this.description,
    this.rating,
    this.difficulty,
    this.totalPoints,
    this.roundIds,
    this.questionIds,
    this.isPublished,
  });

  QuizModel.fromFirebase(DocumentSnapshot document, String id) {
    this.uid = id;
    this.userId = document.data['userId'] ?? '';
    this.title = document.data['title'] ?? '';
    this.rating = document.data['rating'] ?? 0;
    this.difficulty = document.data['difficulty'] ?? 0;
    this.totalPoints = document.data['totalPoints'] ?? 0;
    this.description = document.data['description'] ?? '';
    this.isPublished = document.data['isPublished'] ?? false;
    roundIds = List<String>();
    if (document['roundIds'] != null) {
      document['roundIds'].forEach((id) {
        roundIds.add(id);
      });
    }
    questionIds = List<String>();
    if (document['questionIds'] != null) {
      document['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }
}
