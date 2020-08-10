import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String uid;
  String id;
  String title;
  String description;
  int rating;
  int difficulty;
  List<String> questionIds;
  double totalPoints;
  bool isPublished;
  Timestamp lastUpdated;
  Timestamp createAt;

  RoundModel({
    this.uid,
    this.id,
    this.title,
    this.description,
    this.questionIds,
    this.rating,
    this.difficulty,
    this.totalPoints,
    this.isPublished,
  });

  RoundModel.fromJSON(json) {
    this.id = json['id'] ?? '';
    this.uid = json['uid'] ?? '';
    this.lastUpdated = json['lastUpdated'];
    this.createAt = json['createAt'];
    this.title = json['title'] ?? '';
    this.description = json['description'] ?? '';
    this.rating = json['rating'] ?? 0;
    this.difficulty = json['difficulty'] ?? 0;
    this.totalPoints = json['totalPoints'] ?? 0;
    this.isPublished = json['isPublished'] ?? false;
    questionIds = List<String>();
    if (json['questionIds'] != null) {
      json['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }
  RoundModel.fromFirebase(DocumentSnapshot document, String id) {
    this.id = id;
    this.uid = document.data['uid'] ?? '';
    this.lastUpdated = document.data['lastUpdated'];
    this.createAt = document.data['createAt'];
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
