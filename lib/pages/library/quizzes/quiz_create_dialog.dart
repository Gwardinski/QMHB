import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class QuizCreateDialog extends StatefulWidget {
  final RoundModel initialRound;

  QuizCreateDialog({
    this.initialRound,
  });
  @override
  _QuizAddModalState createState() => _QuizAddModalState();
}

class _QuizAddModalState extends State<QuizCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  QuizModel _quiz;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _quiz = QuizModel(title: "");
    if (widget.initialRound != null) {
      _quiz.rounds = [widget.initialRound.id];
      _quiz.totalPoints = widget.initialRound.totalPoints;
    }
  }

  _updateError(String val) {
    setState(() {
      _error = val;
    });
  }

  _updateIsLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _createQuiz();
    }
  }

  _createQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final token = Provider.of<UserDataStateModel>(context, listen: false).token;
      final quizService = Provider.of<QuizService>(context, listen: false);
      final refreshService = Provider.of<RefreshService>(context, listen: false);
      try {
        await quizService.createQuiz(
          quiz: _quiz,
          token: token,
        );
        refreshService.quizAndRoundRefresh();
        Provider.of<NavigationService>(context, listen: false).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to add Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.initialRound != null
                    ? Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "Quiz will be created with:",
                            ),
                            Text(
                              "\n\"${widget.initialRound?.title}\"\n",
                            ),
                          ],
                        ),
                      )
                    : Container(),
                FormInput(
                  initialValue: _quiz.title,
                  validate: validateForm,
                  labelText: "Quiz Name",
                  onChanged: (val) {
                    setState(() {
                      _quiz.title = val;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: ButtonPrimary(
                    text: "Create",
                    isLoading: _isLoading,
                    onPressed: _onSubmit,
                    fullWidth: false,
                  ),
                ),
                _error != "" ? FormError(error: _error) : Container(),
                ButtonText(
                  onTap: () => Navigator.of(context).pop(),
                  text: "Close",
                  type: ButtonTextType.SECONDARY,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
