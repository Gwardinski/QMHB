import 'dart:async';

class RefresherService {
  StreamController<bool> _questionController = StreamController<bool>();
  StreamController<bool> _roundController = StreamController<bool>();
  StreamController<bool> _quizController = StreamController<bool>();
  Stream questionListener;
  Stream roundListener;
  Stream quizListener;

  RefresherService() {
    questionListener = _questionController.stream.asBroadcastStream();
    roundListener = _roundController.stream.asBroadcastStream();
    quizListener = _quizController.stream.asBroadcastStream();
  }

  questionRefresh() {
    _questionController.add(true);
  }

  roundRefresh() {
    _roundController.add(true);
  }

  roundAndQuestionRefresh() {
    _roundController.add(true);
    _questionController.add(true);
  }

  quizAndRoundRefresh() {
    _quizController.add(true);
    _roundController.add(true);
  }

  quizRefresh() {
    _quizController.add(true);
    _roundController.add(true);
    _questionController.add(true);
  }
}
