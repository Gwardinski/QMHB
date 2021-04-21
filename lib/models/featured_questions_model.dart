import 'package:qmhb/models/question_model.dart';

class FeaturedQuestions {
  String id;
  String title;
  String description;
  List<QuestionModel> questionModels;
  String searchString;
  String selectedCategory;
  String sortBy;

  FeaturedQuestions({
    this.id,
    this.title,
    this.description,
    this.questionModels,
    this.searchString,
    this.selectedCategory,
    this.sortBy,
  });

  FeaturedQuestions.fromJson(json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.searchString = json['searchString'];
    this.selectedCategory = json['selectedCategory'];
    this.sortBy = json['sortBy'];
    this.questionModels = [];
    if (json['questionModels'] != null) {
      json['questionModels'].forEach((r) {
        this.questionModels.add(QuestionModel.fromJson(r));
      });
    }
  }
}
