import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  String uid;
  String title;

  QuizModel({
    this.uid,
    this.title,
  });

  QuizModel.fromFirebase(DocumentSnapshot document) {
    this.uid = document.data['uid'] ?? '';
    this.title = document.data['title'] ?? '';
  }
}
