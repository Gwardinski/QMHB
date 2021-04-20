import 'package:qmhb/models/round_model.dart';

class FeaturedRounds {
  String id;
  String title;
  String description;
  List<RoundModel> roundModels;
  String searchString;
  String selectedCategory;
  String sortBy;

  FeaturedRounds({
    this.id,
    this.title,
    this.description,
    this.roundModels,
    this.searchString,
    this.selectedCategory,
    this.sortBy,
  });

  FeaturedRounds.fromJson(json) {
    this.id = json['id'];
    this.title = json['title'];
    this.description = json['description'];
    this.searchString = json['searchString'];
    this.selectedCategory = json['selectedCategory'];
    this.sortBy = json['sortBy'];
    this.roundModels = [];
    if (json['roundModels'] != null) {
      json['roundModels'].forEach((r) {
        this.roundModels.add(RoundModel.fromJson(r));
      });
    }
  }
}
