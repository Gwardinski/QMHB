import 'package:cloud_firestore/cloud_firestore.dart';

class RoundModel {
  String id;
  String title;

  RoundModel({
    this.id,
    this.title,
  });

  RoundModel.fromFirebase(DocumentSnapshot document) {
    this.id = document.data['id'] ?? '';
    this.title = document.data['title'] ?? '';
  }
}
