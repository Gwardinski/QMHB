import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/editor/round_select_questions.dart';
import 'package:qmhb/pages/library/rounds/editor/round_reorder_questions.dart';
import 'package:qmhb/pages/library/rounds/editor/round_details_editor.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/editor_layout.dart';
import 'package:qmhb/shared/widgets/editor_nav_button.dart';

import '../../../../get_it.dart';

class RoundEditorPage extends StatefulWidget {
  final RoundModel round;
  final QuizModel parentQuiz;

  RoundEditorPage({
    this.round,
    this.parentQuiz,
  });
  @override
  _RoundEditorPageState createState() => _RoundEditorPageState();
}

class _RoundEditorPageState extends State<RoundEditorPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;
  GlobalKey<FormState> _formKeyRoundEditor = GlobalKey<FormState>();
  RoundModel _round;
  String _savedRound;
  bool _isNewRound = true;
  bool _isLoading = false;
  RoundService _roundService;
  NavigationService _navigationService;
  RefreshService _refreshService;
  String _token;

  _setRound(RoundModel round) => setState(() => _round = round);
  _setSavedRound() => setState(() => _savedRound = json.encode(_round));
  _setIsLoading(bool val) => setState(() => _isLoading = val);

  @override
  void initState() {
    super.initState();
    _roundService = Provider.of<RoundService>(context, listen: false);
    _navigationService = Provider.of<NavigationService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _initPageViewController();
    _initRoundModel();
  }

  void _initPageViewController() {
    _currentPage = 0;
    _controller.addListener(() {
      setState(() => _currentPage = _controller.page.toInt());
    });
  }

  void _initRoundModel() {
    if (widget.round == null) {
      _initNewRound();
    } else {
      _getExistingRound();
    }
  }

  void _initNewRound() {
    setState(() {
      _round = RoundModel.newRound();
      _isNewRound = true;
    });
  }

  void _getExistingRound() {
    setState(() {
      _round = widget.round;
      _isNewRound = false;
    });
    _setSavedRound();
    _getRound();
  }

  Future<void> _getRound() async {
    _setIsLoading(true);
    try {
      final round = await _roundService.getRound(
        token: _token,
        id: _round.id,
      );
      _setRound(round);
      _setSavedRound();
    } catch (e) {
      print(e);
    } finally {
      _setIsLoading(false);
    }
  }

  void _onSave() {
    if (_formKeyRoundEditor.currentState.validate()) {
      _setSavedRound();
      _isNewRound ? _createRound() : _editRound();
    } else {
      _controller.jumpToPage(0);
    }
  }

  Future<void> _createRound() async {
    _setIsLoading(true);
    try {
      await _roundService.createRound(
        round: _round,
        token: _token,
      );
      _refreshService.roundAndQuestionRefresh();
      _showSnackbar('Round Saved Successfully!');
      setState(() => _isNewRound = false);
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to create Round. Please try again.');
    } finally {
      _setIsLoading(false);
    }
  }

  Future<void> _editRound() async {
    _setIsLoading(true);
    try {
      await _roundService.editRound(
        round: _round,
        token: _token,
      );
      _refreshService.roundRefresh();
      _showSnackbar('Round Saved Successfully!');
    } catch (e) {
      print(e.toString());
      _showSnackbar('Failed to save Round. Please try again.');
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
    String current = json.encode(_round).toString();
    if (_savedRound != current) {
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
    bool useLargeLayout = MediaQuery.of(context).size.width > 800.0;
    getIt<AppSize>().updateSize(useLargeLayout);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AppBarButton(
              highlight: true,
              onTap: _closeEditor,
              title: widget.parentQuiz != null
                  ? useLargeLayout
                      ? 'Back to Quiz Editor'
                      : 'Quiz'
                  : useLargeLayout
                      ? 'Close Editor'
                      : 'Close',
              leftIcon: Icons.arrow_back,
            ),
            Text(
              _isNewRound
                  ? useLargeLayout
                      ? "Create New Round"
                      : "Create"
                  : useLargeLayout
                      ? "Edit Round"
                      : "Edit",
            ),
            AppBarButton(
              highlight: true,
              onTap: _onSave,
              title: useLargeLayout ? "Save Changed" : "Save",
              rightIcon: Icons.save,
            ),
          ],
        ),
      ),
      body: EditorLayout(
        isLoading: _isLoading,
        topMenu: EditorMenuTop(
          currentPage: _currentPage,
          controller: _controller,
        ),
        pageView: Stack(
          children: [
            PageView(
              controller: _controller,
              physics: (useLargeLayout || _isNewRound)
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              children: [
                RoundDetailsEditor(
                  round: _round,
                  onRoundUpdate: _setRound,
                  isNewRound: _isNewRound,
                  formkey: _formKeyRoundEditor,
                ),
                RoundSelectQuestions(
                  onUpdateQuestions: _setRound,
                  round: _round,
                ),
                RoundReorderQuestions(
                  onReorder: _setRound,
                  round: _round,
                ),
                // TODO
                Container(
                  child: Center(
                    child: Text("TODO - Publish Page"),
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

class EditorMenuTop extends StatelessWidget {
  final controller;
  final currentPage;

  const EditorMenuTop({
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: EditorNavButton(
              title: "Details",
              onTap: () => controller.jumpToPage(0),
              highlight: currentPage == 0,
              disable: false,
            ),
          ),
          Expanded(
            child: EditorNavButton(
              title: "Questions",
              onTap: () => controller.jumpToPage(1),
              highlight: currentPage == 1,
              disable: false,
            ),
          ),
          Expanded(
            child: EditorNavButton(
              title: "Order",
              onTap: () => controller.jumpToPage(2),
              highlight: currentPage == 2,
              disable: false,
            ),
          ),
          Expanded(
            child: EditorNavButton(
              title: "Publish",
              onTap: () => controller.jumpToPage(3),
              highlight: currentPage == 3,
              disable: false,
            ),
          ),
        ],
      ),
    );
  }
}
