import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_select_rounds.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_details_editor.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';

import '../../../../get_it.dart';

class QuizEditorPage extends StatefulWidget {
  final QuizModel quiz;

  QuizEditorPage({
    this.quiz,
  });
  @override
  _QuizEditorPageState createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  GlobalKey<FormState> _formKeyQuizEditor = GlobalKey<FormState>();
  QuizModel _quiz;
  String _savedQuiz;
  bool _isNewQuiz = true;
  QuizService _quizService;
  NavigationService _navigationService;
  RefreshService _refreshService;
  String _token;

  _setQuiz(QuizModel quiz) => setState(() => _quiz = quiz);
  _setSavedQuiz() => setState(() => _savedQuiz = json.encode(_quiz));

  @override
  void initState() {
    super.initState();
    _quizService = Provider.of<QuizService>(context, listen: false);
    _navigationService = Provider.of<NavigationService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _initQuizModel();
  }

  void _initQuizModel() {
    if (widget.quiz == null) {
      _initNewQuiz();
    } else {
      _getExistingQuiz();
    }
  }

  void _initNewQuiz() {
    setState(() {
      _quiz = QuizModel.newQuiz();
      _isNewQuiz = true;
    });
  }

  void _getExistingQuiz() {
    setState(() {
      _quiz = widget.quiz;
      _isNewQuiz = false;
    });
    _setSavedQuiz();
    _getQuiz();
  }

  Future<void> _getQuiz() async {
    try {
      final quiz = await _quizService.getQuiz(
        token: _token,
        id: _quiz.id,
      );
      _setQuiz(quiz);
      _setSavedQuiz();
    } catch (e) {
      print(e);
    } finally {}
  }

  void _onSave() {
    if (_formKeyQuizEditor.currentState.validate()) {
      _setSavedQuiz();
      _isNewQuiz ? _createQuiz() : _editQuiz();
    }
  }

  Future<void> _createQuiz() async {
    try {
      await _quizService.createQuiz(
        quiz: _quiz,
        token: _token,
      );
      _refreshService.quizAndRoundRefresh();
      _showSnackbar('Quiz Saved Successfully!');
      setState(() => _isNewQuiz = false);
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to create Quiz. Please try again.');
    }
  }

  Future<void> _editQuiz() async {
    try {
      await _quizService.editQuiz(
        quiz: _quiz,
        token: _token,
      );
      _refreshService.quizRefresh();
      _showSnackbar('Quiz Saved Successfully!');
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to save Quiz. Please try again.');
    }
  }

  void _showSnackbar(String val) {
    final snackBar = SnackBar(
      content: Text(val),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).accentColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _closeEditor() {
    String current = json.encode(_quiz).toString();
    if (_savedQuiz != current) {
      _showAlert();
    } else {
      _navigationService.pop();
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Unsaved Changes"),
          content: Text("You have unsaved changes.\nAre you sure you wish to go back ?"),
          actions: [
            TextButton(
              child: Text('Close Without Saving'),
              onPressed: () {
                _navigationService.pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Continue Editing'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _containsRound(RoundModel round) {
    return _quiz.rounds.contains(round.id);
  }

  Future<void> _updateQuiz(RoundModel round) async {
    QuizModel updatedQuiz = _quiz;
    if (_containsRound(round)) {
      updatedQuiz.rounds.remove(round.id);
      updatedQuiz.roundModels.removeWhere((r) => r.id == round.id);
    } else {
      updatedQuiz.rounds.add(round.id);
      updatedQuiz.roundModels.add(round);
    }
    _setQuiz(updatedQuiz);
  }

  @override
  Widget build(BuildContext context) {
    bool useLargeLayout = MediaQuery.of(context).size.width > 800.0;
    getIt<AppSize>().updateSize(useLargeLayout);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AppBarButton(
              highlight: true,
              onTap: _closeEditor,
              title: useLargeLayout ? 'Close Editor' : 'Close',
              leftIcon: Icons.arrow_back,
            ),
            Text(
              _isNewQuiz
                  ? useLargeLayout
                      ? "Create New Quiz"
                      : "Create"
                  : useLargeLayout
                      ? "Edit Quiz"
                      : "Edit",
            ),
            AppBarButton(
              highlight: true,
              onTap: _onSave,
              title: useLargeLayout ? "Save Changes" : "Save",
              rightIcon: Icons.save,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          QuizDetailsEditor(
            quiz: _quiz,
            onQuizUpdate: _setQuiz,
            formkey: _formKeyQuizEditor,
          ),
          QuizSelectedRounds(
            quiz: _quiz,
            onReorder: _setQuiz,
            onTap: (round) => _updateQuiz(round),
            containsItem: (round) => _containsRound(round),
          ),
          Divider(),
          QuizSelectRounds(
            quiz: _quiz,
            onTap: (round) => _updateQuiz(round),
            containsItem: (round) => _containsRound(round),
          ),
        ],
      ),
    );
  }
}
