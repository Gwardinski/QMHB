import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/user_model.dart';

class DatabaseService {
  // DB collections
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  // TODO handle this in single request
  Future<List<QuestionModel>> getQuestionsByIds(List<String> questionIds) async {
    List<QuestionModel> questions = [];
    for (var id in questionIds) {
      DocumentSnapshot fbquestion = await _questionsCollection.document(id).get();
      try {
        // add id in here ?
        QuestionModel question = QuestionModel.fromFirebase(fbquestion, id);
        questions.add(question);
      } catch (e) {
        print("failed to find question with ID of $id");
      }
    }
    return questions;
  }

  // Questions

  addQuestionToFirebase(QuestionModel questionModel, UserModel userModel) async {
    DocumentReference doc = await _addQuestionToFirebaseCollection(questionModel, userModel.uid);
    userModel.questionIds.add(doc.documentID);
    // await updateUserDataOnFirebase(userModel);
  }

  Future _addQuestionToFirebaseCollection(QuestionModel questionModel, String uid) async {
    return await _questionsCollection.add({
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": false,
      "uid": uid,
    });
  }

  editQuestionOnFirebase(QuestionModel questionModel, UserModel userModel) async {
    await _editQuestionOnFirebaseCollection(questionModel, userModel.uid);
    // await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editQuestionOnFirebaseCollection(QuestionModel questionModel, String uid) async {
    // TODO - wrong ID here!
    // return await _questionsCollection.document(questionModel.uid).setData({
    //   "question": questionModel.question,
    //   "answer": questionModel.answer,
    //   "category": questionModel.category,
    //   "difficulty": questionModel.difficulty,
    //   "points": questionModel.points,
    //   "isPublished": questionModel.isPublished,
    //   "uid": uid,
    // });
  }
}
