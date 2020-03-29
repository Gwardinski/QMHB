import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/user_model.dart';

class DatabaseService {
  // DB collections
  final CollectionReference _usersCollection = Firestore.instance.collection('users');
  final CollectionReference _quizzesCollection = Firestore.instance.collection('quizzes');
  final CollectionReference _roundsCollection = Firestore.instance.collection('rounds');
  final CollectionReference _questionsCollection = Firestore.instance.collection('questions');

  // Log in user
  Future<DocumentSnapshot> getUserFromUsersCollectionUsingUID(uid) async {
    return await _usersCollection.document(uid).get();
  }

  // stream user changes - called on base widget UserListener
  Stream<UserModel> getUserStream(id) {
    return _usersCollection.document(id).snapshots().map((user) {
      final test = UserModel.fromFirebase(user.data);
      return test;
    });
  }

  // Get data from Firebase by ID
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

  Future<List<RoundModel>> getRoundsByIds(List<String> roundIds) async {
    List<RoundModel> rounds = [];
    for (var id in roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      try {
        RoundModel round = RoundModel.fromFirebase(fbround, id);
        rounds.add(round);
      } catch (e) {
        print("failed to find round with ID of $id");
      }
    }
    return rounds;
  }

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

  // Update user on Firebase
  Future updateUserDataOnFirebase(UserModel userModel) async {
    return await _usersCollection.document(userModel.uid).setData({
      "uid": userModel.uid,
      "displayName": userModel.displayName,
      "email": userModel.email,
      "quizIds": userModel.quizIds,
      "roundIds": userModel.roundIds,
      "questionIds": userModel.questionIds,
      "recentQuizIds": userModel.recentQuizIds,
      "recentRoundIds": userModel.recentRoundIds,
      "recentQuestionIds": userModel.recentQuestionIds,
      "lastUpdated": DateTime.now().toString(),
    });
  }

  // Quizzes

  addQuizToFirebase(QuizModel quizModel, UserModel userModel) async {
    DocumentReference doc = await _addQuizToFirebaseCollection(quizModel, userModel.uid);
    userModel.quizIds.add(doc.documentID);
    _updateUserRecentQuizzes(userModel, doc.documentID);
    await updateUserDataOnFirebase(userModel);
  }

  Future _addQuizToFirebaseCollection(QuizModel quizModel, String userId) async {
    return await _quizzesCollection.add({
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "isPublished": false,
      "userId": userId,
    });
  }

  editQuizOnFirebase(QuizModel quizModel, UserModel userModel) async {
    await _editQuizOnFirebaseCollection(quizModel, userModel.uid);
    _updateUserRecentQuizzes(userModel, quizModel.uid);
    await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editQuizOnFirebaseCollection(QuizModel quizModel, String userId) async {
    return await _quizzesCollection.document(quizModel.uid).setData({
      "title": quizModel.title,
      "description": quizModel.description,
      "roundIds": quizModel.roundIds,
      "totalPoints": quizModel.totalPoints,
      "isPublished": false,
      "userId": userId,
    });
  }

  _updateUserRecentQuizzes(UserModel userModel, String quizId) {
    List<String> quizIds = userModel.recentQuizIds;
    quizIds.remove(quizId);
    quizIds.add(quizId);
    if (quizIds.length > 9) {
      //TODO - this may not work
      quizIds = quizIds.sublist(0, 9);
    }
    userModel.recentQuizIds = quizIds;
    return userModel;
  }

  // Rounds

  addRoundToFirebase(RoundModel roundModel, UserModel userModel) async {
    DocumentReference doc = await _addRoundToFirebaseCollection(roundModel, userModel.uid);
    userModel.roundIds.add(doc.documentID);
    _updateUserRecentRounds(userModel, doc.documentID);
    await updateUserDataOnFirebase(userModel);
  }

  Future _addRoundToFirebaseCollection(RoundModel roundModel, String userId) async {
    return await _roundsCollection.add({
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "isPublished": false,
      "userId": userId,
    });
  }

  editRoundOnFirebase(RoundModel roundModel, UserModel userModel) async {
    await _editRoundOnFirebaseCollection(roundModel, userModel.uid);
    _updateUserRecentRounds(userModel, roundModel.uid);
    await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editRoundOnFirebaseCollection(RoundModel roundModel, String userId) async {
    return await _roundsCollection.document(roundModel.uid).setData({
      "title": roundModel.title,
      "description": roundModel.description,
      "questionIds": roundModel.questionIds,
      "totalPoints": roundModel.totalPoints,
      "isPublished": false,
      "userId": userId,
    });
  }

  _updateUserRecentRounds(UserModel userModel, String roundId) {
    List<String> roundIds = userModel.recentRoundIds;
    roundIds.remove(roundId);
    roundIds.add(roundId);
    if (roundIds.length > 9) {
      //TODO - this may not work
      roundIds = roundIds.sublist(0, 9);
    }
    userModel.recentRoundIds = roundIds;
    return userModel;
  }

  // Questions

  addQuestionToFirebase(QuestionModel questionModel, UserModel userModel) async {
    DocumentReference doc = await _addQuestionToFirebaseCollection(questionModel, userModel.uid);
    userModel.questionIds.add(doc.documentID);
    _updateUserRecentQuestions(userModel, doc.documentID);
    await updateUserDataOnFirebase(userModel);
  }

  Future _addQuestionToFirebaseCollection(QuestionModel questionModel, String userId) async {
    return await _questionsCollection.add({
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": false,
      "userId": userId,
    });
  }

  editQuestionOnFirebase(QuestionModel questionModel, UserModel userModel) async {
    await _editQuestionOnFirebaseCollection(questionModel, userModel.uid);
    _updateUserRecentQuestions(userModel, questionModel.uid);
    await updateUserDataOnFirebase(userModel);
  }

  Future<void> _editQuestionOnFirebaseCollection(QuestionModel questionModel, String userId) async {
    return await _questionsCollection.document(questionModel.uid).setData({
      "question": questionModel.question,
      "answer": questionModel.answer,
      "category": questionModel.category,
      "difficulty": questionModel.difficulty,
      "points": questionModel.points,
      "isPublished": questionModel.isPublished,
      "userId": userId,
    });
  }

  _updateUserRecentQuestions(UserModel userModel, String questionId) {
    List<String> questionIds = userModel.recentQuestionIds;
    questionIds.remove(questionId);
    questionIds.add(questionId);
    if (questionIds.length > 9) {
      //TODO - this may not work
      questionIds = questionIds.sublist(0, 9);
    }
    userModel.recentQuestionIds = questionIds;
    return userModel;
  }

  deleteQuestion(UserModel user, QuestionModel question) async {
    await _removeQuestionFromAllRounds(user, question);
    await _removeQuestionUser(user, question);
    await _questionsCollection.document(question.uid).delete();
  }

  _removeQuestionFromAllRounds(UserModel user, QuestionModel question) async {
    for (var id in user.roundIds) {
      DocumentSnapshot fbround = await _roundsCollection.document(id).get();
      try {
        RoundModel round = RoundModel.fromFirebase(fbround, id);
        round.questionIds.remove(question.uid);
        round.totalPoints -= question.points;
        await _editRoundOnFirebaseCollection(round, user.uid);
      } catch (e) {
        print("failed to find round with ID of $id");
      }
    }
  }

  _removeQuestionUser(UserModel user, QuestionModel question) async {
    user.questionIds.remove(question.uid);
    user.recentQuestionIds.remove(question.uid);
    await updateUserDataOnFirebase(user);
  }
}
