import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/library/questions/editor/question_details_editor.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/editor_layout.dart';
import 'package:qmhb/shared/widgets/editor_nav_button.dart';
import '../../../../get_it.dart';

class QuestionEditorPage extends StatefulWidget {
  final QuestionModel question;
  final RoundModel parentRound;
  final questionService;
  final refreshService;
  final token;

  QuestionEditorPage({
    @required this.questionService,
    @required this.refreshService,
    @required this.token,
    this.question,
    this.parentRound,
  });
  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditorPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  GlobalKey<FormState> _formKeyQuestionEditor = GlobalKey<FormState>();
  QuestionModel _question;
  String _savedQuestion;
  bool _isNewQuestion = true;
  bool _isLoading = false;

  _setQuestion(QuestionModel question) => setState(() => _question = question);
  _setSavedQuestion() => setState(() => _savedQuestion = json.encode(_question));
  _setIsLoading(bool val) => setState(() => _isLoading = val);

  @override
  void initState() {
    super.initState();
    _initPageViewController();
    _initQuestionModel();
  }

  void _initPageViewController() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() => _currentPage = _controller.page.toInt());
    });
  }

  void _initQuestionModel() {
    if (widget.question != null) {
      _getExistingQuestion();
    } else {
      _initNewQuestion();
    }
  }

  void _initNewQuestion() {
    setState(() {
      _question = QuestionModel.newQuestion();
      _isNewQuestion = true;
    });
  }

  void _getExistingQuestion() {
    setState(() {
      _question = widget.question;
      _isNewQuestion = false;
    });
    _setSavedQuestion();
    _getQuestion();
  }

  Future<void> _getQuestion() async {
    _setIsLoading(true);
    try {
      final question = await widget.questionService.getQuestion(
        token: widget.token,
        id: _question.id,
      );
      _setQuestion(question);
      _setSavedQuestion();
    } catch (e) {
      print(e);
    } finally {
      _setIsLoading(false);
    }
  }

  void _onSave() {
    if (_formKeyQuestionEditor.currentState.validate()) {
      _setSavedQuestion();
      _isNewQuestion ? _createQuestion() : _editQuestion();
    } else {
      _controller.jumpToPage(0);
    }
  }

  Future<void> _createQuestion() async {
    _setIsLoading(true);
    try {
      await widget.questionService.createQuestion(
        question: _question,
        token: widget.token,
      );
      widget.refreshService.roundAndQuestionRefresh();
      _showSnackbar('Question Saved Successfully!');
      setState(() => _isNewQuestion = false);
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to create Question. Please try again.');
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> _editQuestion() async {
    _setIsLoading(true);
    try {
      await widget.questionService.editQuestion(
        question: _question,
        token: widget.token,
      );
      widget.refreshService.roundAndQuestionRefresh();
      _showSnackbar('Question Saved Successfully!');
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to save Question. Please try again.');
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
    String current = json.encode(_question).toString();
    if (_savedQuestion != current) {
      _showAlert();
    } else {
      Navigator.of(context).pop();
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
                // double pop is intentional
                Navigator.of(context).pop();
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
    bool useLargeLayout = MediaQuery.of(context).size.width > 800.0;
    getIt<AppSize>().updateSize(useLargeLayout);
    return Dialog(
      insetPadding: EdgeInsets.all(200),
      child: Scaffold(
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
                title: widget.parentRound != null
                    ? useLargeLayout
                        ? 'Back to Round Editor'
                        : 'Round'
                    : useLargeLayout
                        ? 'Close Editor'
                        : 'Close',
                leftIcon: Icons.arrow_back,
              ),
              Text(
                _isNewQuestion
                    ? useLargeLayout
                        ? "Create New Question"
                        : "Create"
                    : useLargeLayout
                        ? "Edit Question"
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
        body: EditorLayout(
          isLoading: _isLoading,
          topMenu: QuestionEditorTopMenu(
            currentPage: _currentPage,
            controller: _controller,
          ),
          pageView: Stack(
            children: [
              PageView(
                controller: _controller,
                physics: (useLargeLayout || _isNewQuestion)
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                children: [
                  QuestionDetailsEditor(
                    question: _question,
                    isNewQuestion: _isNewQuestion,
                    onQuestionUpdate: _setQuestion,
                    formkey: _formKeyQuestionEditor,
                  ),
                  // TODO
                  Container(
                    child: Center(
                      child: Text("TODO - Image / Spotify Page"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionEditorTopMenu extends StatelessWidget {
  final controller;
  final currentPage;

  const QuestionEditorTopMenu({
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              title: "Attachments",
              onTap: () => controller.jumpToPage(1),
              highlight: currentPage == 1,
              disable: false,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }
}
