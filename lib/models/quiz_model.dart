import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String id;
  String uid;
  String title;
  String description;
  String imageURL;
  int rating;
  int difficulty;
  double totalPoints;
  bool isPublished;
  List<String> roundIds;
  List<String> questionIds;
  DateTime lastUpdated;
  DateTime createdAt;

  QuizModel({
    this.id,
    this.uid,
    this.title,
    this.description,
    this.imageURL,
    this.rating,
    this.difficulty,
    this.totalPoints,
    this.roundIds,
    this.questionIds,
    this.isPublished,
  });

  QuizModel.fromJSON(json) {
    this.id = json['id'];
    this.uid = json['uid'];
    this.lastUpdated = json['lastUpdated'];
    this.createdAt = json['createdAt'];
    this.title = json['title'];
    this.rating = json['rating'] ?? 0;
    this.difficulty = json['difficulty'] ?? 0;
    this.totalPoints = json['totalPoints'] ?? 0;
    this.description = json['description'];
    this.imageURL = json['imageURL'];
    this.isPublished = json['isPublished'] ?? false;
    roundIds = List<String>();
    if (json['roundIds'] != null) {
      json['roundIds'].forEach((id) {
        roundIds.add(id);
      });
    }
    questionIds = List<String>();
    if (json['questionIds'] != null) {
      json['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }

  QuizModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data()['id'];
    this.uid = document.data()['uid'];
    this.lastUpdated = document.data()['lastUpdated'].toDate();
    this.createdAt = document.data()['createdAt'].toDate();
    this.title = document.data()['title'];
    this.rating = document.data()['rating'] ?? 0;
    this.difficulty = document.data()['difficulty'] ?? 0;
    this.totalPoints = document.data()['totalPoints'] ?? 0;
    this.description = document.data()['description'];
    this.imageURL = document.data()['imageURL'];
    this.isPublished = document.data()['isPublished'] ?? false;
    roundIds = List<String>();
    if (document.data()['roundIds'] != null) {
      document.data()['roundIds'].forEach((id) {
        roundIds.add(id);
      });
    }
    questionIds = List<String>();
    if (document.data()['questionIds'] != null) {
      document.data()['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }

  QuizModel.newRound();
}
