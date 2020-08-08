import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/user_model.dart';

class QuizCollectionService {
  // DB collection
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');

  // TODO handle this in single request
  Future<List<QuizModel>> getQuizzesByIds(List<String> quizIds) async {
    List<QuizModel> quizzes = [];
    for (var id in quizIds) {
      DocumentSnapshot fbquiz = await _quizzesCollection.document(id).get();
      try {
        QuizModel quiz = QuizModel.fromFirebase(fbquiz, id);
        quizzes.add(quiz);
      } catch (e) {
        print("failed to find quiz with ID of $id");
      }
    }
    return quizzes;
  }

  // Quizzes

  addQuizToFirebase(QuizModel quizModel, UserModel userModel) async {
    DocumentReference doc = await _addQuizToFirebaseCollection(quizModel, userModel.uid);
    userModel.quizIds.add(doc.documentID);
    // await updateUserDataOnFirebase(userModel);
  }

  Future _addQuizToFirebaseCollection(QuizModel quizModel, String uid) async {
    return await _quizzesCollection.add({
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "uid": uid,
    });
  }

  editQuizOnFirebase(QuizModel quizModel, UserModel userModel) async {
    await _editQuizOnFirebaseCollection(quizModel, userModel.uid);
    // await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editQuizOnFirebaseCollection(QuizModel quizModel, String uid) async {
    // TODO - wrong ID here!
    // return await _quizzesCollection.document(quizModel.uid).setData({
    //   "title": quizModel.title,
    //   "description": quizModel.description,
    //   "roundIds": quizModel.roundIds,
    //   "totalPoints": quizModel.totalPoints,
    //   "isPublished": false,
    //   "uid": uid,
    // });
  }
}
