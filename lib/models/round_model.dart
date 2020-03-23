import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String uid;
  String title;
  String description;
  int rating;
  int difficulty;
  List<String> questionIds;

  RoundModel({
    this.uid,
    this.title,
    this.description,
    this.questionIds,
    this.rating,
    this.difficulty,
  });

  RoundModel.fromFirebase(DocumentSnapshot document) {
    this.uid = document.data['uid'] ?? '';
    this.title = document.data['title'] ?? '';
    this.description = document.data['description'] ?? '';
    this.rating = document.data['rating'] ?? 0;
    this.difficulty = document.data['difficulty'] ?? 0;
    questionIds = List<String>();
    if (document['questionIds'] != null) {
      document['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }
}
