import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String uid;
  String id;
  String title;
  String description;
  String imageURL;
  int rating;
  int difficulty;
  List<String> questionIds;
  double totalPoints;
  bool isPublished;
  DateTime lastUpdated;
  DateTime createdAt;

  RoundModel({
    this.uid,
    this.id,
    this.title,
    this.description,
    this.imageURL,
    this.questionIds,
    this.rating,
    this.difficulty,
    this.totalPoints,
    this.isPublished,
  });

  RoundModel.fromJSON(json) {
    this.id = json['id'];
    this.uid = json['uid'];
    this.lastUpdated = json['lastUpdated'];
    this.createdAt = json['createdAt'];
    this.title = json['title'];
    this.description = json['description'];
    this.imageURL = json['imageURL'];
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
  RoundModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data()['id'];
    this.uid = document.data()['uid'];
    this.lastUpdated = document.data()['lastUpdated'].toDate();
    this.createdAt = document.data()['createdAt'].toDate();
    this.title = document.data()['title'];
    this.description = document.data()['description'];
    this.imageURL = document.data()['imageURL'];
    this.rating = document.data()['rating'] ?? 0;
    this.difficulty = document.data()['difficulty'] ?? 0;
    this.totalPoints = document.data()['totalPoints'] ?? 0;
    this.isPublished = document.data()['isPublished'] ?? false;
    questionIds = List<String>();
    if (document.data()['questionIds'] != null) {
      document.data()['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }

  RoundModel.newRound();
}
