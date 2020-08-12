import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';

class QuestionCollectionService {
  // DB collections
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  // TODO handle this in single request
  Future<List<QuestionModel>> getQuestionsByIds(List<String> questionIds) async {
    List<QuestionModel> questions = [];
    for (var id in questionIds) {
      DocumentSnapshot fbquestion = await _questionsCollection.document(id).get();
      try {
        QuestionModel question = QuestionModel.fromFirebase(fbquestion);
        questions.add(question);
      } catch (e) {
        print("failed to find question with ID of $id");
      }
    }
    return questions;
  }

  Stream<List<QuestionModel>> getRecentQuestionStream() {
    return _questionsCollection.orderBy("lastUpdated").limit(10).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => QuestionModel.fromFirebase(doc)).toList();
    });
  }

  Future<String> addQuestionToFirebaseCollection(
    QuestionModel questionModel,
    String uid,
  ) async {
    final serverTimestamp = Timestamp.now();
    final newDocId = _questionsCollection.document().documentID;
    await _questionsCollection.document(newDocId).setData({
      "id": newDocId,
      "uid": uid,
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": false,
      "createdAt": serverTimestamp,
      "lastUpdated": serverTimestamp,
    });
    return newDocId;
  }

  Future<void> editQuestionOnFirebaseCollection(
    QuestionModel questionModel,
  ) async {
    final serverTimestamp = Timestamp.now();
    return await _questionsCollection.document(questionModel.id).setData({
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "lastUpdated": serverTimestamp,
    });
  }
}
