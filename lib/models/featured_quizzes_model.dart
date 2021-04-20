import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';

class FeaturedQuizzes {
  String id;
  String title;
  String description;
  List<QuizModel> quizModels;
  String searchString;
  String selectedCategory;
  String sortBy;

  FeaturedQuizzes({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.quizModels,
    @required this.searchString,
    @required this.selectedCategory,
    @required this.sortBy,
  });

  FeaturedQuizzes.fromJson(json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.searchString = json['searchString'];
    this.selectedCategory = json['selectedCategory'];
    this.sortBy = json['sortBy'];
    this.quizModels = [];
    if (json['quizModels'] != null) {
      json['quizModels'].forEach((r) {
        this.quizModels.add(QuizModel.fromJson(r));
      });
    }
  }
}
