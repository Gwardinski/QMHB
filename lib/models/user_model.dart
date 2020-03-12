class UserModel {
  String uid;
  String email;
  String displayName;
  List<String> quizIds;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.quizIds,
  });

  UserModel.fromFirebase(data) {
    this.uid = data['uid'];
    this.email = data['email'];
    this.displayName = data['displayName'];
    this.quizIds = data['quizIds'];
  }
}
