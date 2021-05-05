import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/editor/round_select_questions.dart';
import 'package:qmhb/pages/library/rounds/editor/round_details_editor.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';

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
  GlobalKey<FormState> _formKeyRoundEditor = GlobalKey<FormState>();
  RoundModel _round;
  String _savedRound;
  bool _isNewRound = true;
  RoundService _roundService;
  NavigationService _navigationService;
  RefreshService _refreshService;
  String _token;

  _setRound(RoundModel round) => setState(() => _round = round);
  _setSavedRound() => setState(() => _savedRound = json.encode(_round));

  @override
  void initState() {
    super.initState();
    _roundService = Provider.of<RoundService>(context, listen: false);
    _navigationService = Provider.of<NavigationService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _initRoundModel();
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
    try {
      final round = await _roundService.getRound(
        token: _token,
        id: _round.id,
      );
      _setRound(round);
      _setSavedRound();
    } catch (e) {
      print(e);
    } finally {}
  }

  void _onSave() {
    if (_formKeyRoundEditor.currentState.validate()) {
      _setSavedRound();
      _isNewRound ? _createRound() : _editRound();
    }
  }

  Future<void> _createRound() async {
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
    }
  }

  Future<void> _editRound() async {
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

  bool _containsQuestion(QuestionModel question) {
    return _round.questions.contains(question.id);
  }

  Future<void> _updateRound(QuestionModel question) async {
    RoundModel updatedRound = _round;
    if (_containsQuestion(question)) {
      updatedRound.questions.remove(question.id);
      updatedRound.questionModels.removeWhere((r) => r.id == question.id);
    } else {
      updatedRound.questions.add(question.id);
      updatedRound.questionModels.add(question);
    }
    _setRound(updatedRound);
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
              title: useLargeLayout ? "Save Changes" : "Save",
              rightIcon: Icons.save,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            RoundDetailsEditor(
              round: _round,
              onRoundUpdate: _setRound,
              formkey: _formKeyRoundEditor,
            ),
            RoundSelectedQuestions(
              round: _round,
              onReorder: _setRound,
              onTap: (question) => _updateRound(question),
              containsItem: (question) => _containsQuestion(question),
            ),
            Divider(),
            RoundSelectQuestions(
              round: _round,
              onTap: (question) => _updateRound(question),
              containsItem: (question) => _containsQuestion(question),
            ),
          ],
        ),
      ),
    );
  }
}
