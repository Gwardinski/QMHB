import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String uid;
  String userId;
  String title;
  String description;
  int rating;
  int difficulty;
  List<String> questionIds;
  double totalPoints;
  bool isPublished;

  RoundModel({
    this.uid,
    this.userId,
    this.title,
    this.description,
    this.questionIds,
    this.rating,
    this.difficulty,
    this.totalPoints,
    this.isPublished,
  });

  RoundModel.fromFirebase(DocumentSnapshot document, String id) {
    this.uid = id;
    this.userId = document.data['userId'] ?? '';
    this.title = document.data['title'] ?? '';
    this.description = document.data['description'] ?? '';
    this.rating = document.data['rating'] ?? 0;
    this.difficulty = document.data['difficulty'] ?? 0;
    this.totalPoints = document.data['totalPoints'] ?? 0;
    this.isPublished = document.data['isPublished'] ?? false;
    questionIds = List<String>();
    if (document['questionIds'] != null) {
      document['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }
}
