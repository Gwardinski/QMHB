import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_select_rounds.dart';
import 'package:qmhb/pages/library/quizzes/editor/quiz_details_editor.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/editor_layout.dart';
import 'package:qmhb/shared/widgets/editor_nav_button.dart';

class QuizEditorPage extends StatefulWidget {
  final QuizModel quiz;

  QuizEditorPage({
    this.quiz,
  });
  @override
  _QuizEditorPageState createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  GlobalKey<FormState> _formKeyQuizEditor = GlobalKey<FormState>();
  QuizModel _quiz;
  String _savedQuiz;
  bool _isNewQuiz = true;
  bool _isLoading = false;
  QuizService _quizService;
  NavigationService _navigationService;
  RefreshService _refreshService;
  String _token;

  _setQuiz(QuizModel quiz) => setState(() => _quiz = quiz);
  _setSavedQuiz() => setState(() => _savedQuiz = json.encode(_quiz));
  _setIsLoading(bool loading) => setState(() => _isLoading = loading);

  @override
  void initState() {
    super.initState();
    _quizService = Provider.of<QuizService>(context, listen: false);
    _navigationService = Provider.of<NavigationService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _initPageViewController();
    _initQuizModel();
  }

  void _initPageViewController() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() => _currentPage = _controller.page.toInt());
    });
  }

  void _initQuizModel() {
    if (widget.quiz == null) {
      _initNewQuiz();
    } else {
      _getExistingQuiz();
    }
  }

  void _initNewQuiz() {
    final newQuiz = QuizModel.newQuiz();
    setState(() {
      _quiz = newQuiz;
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
    _setIsLoading(true);
    try {
      final quiz = await _quizService.getQuiz(
        token: _token,
        id: _quiz.id,
      );
      _setQuiz(quiz);
      _setSavedQuiz();
    } catch (e) {
      print(e);
    } finally {
      _setIsLoading(false);
    }
  }

  void _onSave() {
    if (_formKeyQuizEditor.currentState.validate()) {
      _setSavedQuiz();
      _isNewQuiz ? _createQuiz() : _editQuiz();
    } else {
      _controller.jumpToPage(0);
    }
  }

  Future<void> _createQuiz() async {
    _setIsLoading(true);
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
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> _editQuiz() async {
    _setIsLoading(true);
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
    } finally {
      _setIsLoading(false);
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

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
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
              title: "Close${isLandscape ? ' Editor' : ''}",
              leftIcon: Icons.arrow_back,
            ),
            Text(
              _isNewQuiz ? "Create${isLandscape ? ' New Quiz' : ''}" : "Edit Quiz",
            ),
            AppBarButton(
              highlight: true,
              onTap: _onSave,
              title: "Save${isLandscape ? ' Changes' : ''}",
              rightIcon: Icons.save,
            ),
          ],
        ),
      ),
      body: EditorLayout(
        isLoading: _isLoading,
        topMenu: EditorMenu(
          currentPage: _currentPage,
          controller: _controller,
        ),
        pageView: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: (isLandscape || _isNewQuiz)
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              children: [
                QuizDetailsEditor(
                  quiz: _quiz,
                  onQuizUpdate: _setQuiz,
                  isNewQuiz: _isNewQuiz,
                  formkey: _formKeyQuizEditor,
                ),
                QuizSelectRounds(
                  onUpdateRounds: _setQuiz,
                  quiz: _quiz,
                ),
                Container(
                  child: Center(
                    child: Text("Publish Page"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditorMenu extends StatelessWidget {
  final controller;
  final currentPage;

  const EditorMenu({
    Key key,
    @required this.controller,
    @required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: EditorNavButton(
              title: "Details",
              onTap: () => controller.jumpToPage(0),
              highlight: currentPage == 0,
              disable: false,
              width: 120,
            ),
          ),
          Flexible(
            child: EditorNavButton(
              title: "Rounds",
              onTap: () => controller.jumpToPage(1),
              highlight: currentPage == 1,
              disable: false,
              width: 120,
            ),
          ),
          Flexible(
            child: EditorNavButton(
              title: "Publish",
              onTap: () => controller.jumpToPage(2),
              highlight: currentPage == 2,
              disable: false,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }
}
