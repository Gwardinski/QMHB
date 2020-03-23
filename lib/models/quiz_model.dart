import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String uid;
  String title;
  String description;
  int rating;
  int difficulty;
  List<String> roundIds;
  List<String> questionIds;

  QuizModel({
    this.uid,
    this.title,
    this.description,
    this.rating,
    this.difficulty,
    this.roundIds,
    this.questionIds,
  });

  QuizModel.fromFirebase(DocumentSnapshot document) {
    this.uid = document.data['uid'] ?? '';
    this.title = document.data['title'] ?? '';
    this.rating = document.data['rating'] ?? 0;
    this.difficulty = document.data['difficulty'] ?? 0;
    this.description = document.data['description'] ?? '';
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
