import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String uid;
  String id;
  String title;
  String description;
  String imageURL;
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
    this.totalPoints = document.data()['totalPoints'] ?? 0;
    this.isPublished = document.data()['isPublished'] ?? false;
    questionIds = List<String>();
    if (document.data()['questionIds'] != null) {
      document.data()['questionIds'].forEach((id) {
        questionIds.add(id);
      });
    }
  }

  toFirebase({
    RoundModel roundModel,
    String docId,
    String uid,
    DateTime lastUpdated,
  }) {
    return {
      "id": docId,
      "uid": uid,
      "title": roundModel.title,
      "description": roundModel.description,
      "imageURL": roundModel.imageURL,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "createdAt": roundModel.createdAt ?? lastUpdated,
      "lastUpdated": lastUpdated,
    };
  }

  RoundModel.newRound();
}
