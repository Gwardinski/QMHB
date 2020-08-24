import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class QuizAdd extends StatefulWidget {
  final RoundModel intialRound;

  QuizAdd({
    this.intialRound,
  });
  @override
  _RoundAddState createState() => _RoundAddState();
}

class _RoundAddState extends State<QuizAdd> {
  final _formKey = GlobalKey<FormState>();
  QuizModel _quiz;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _quiz = QuizModel.newRound();
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
      final quizService = Provider.of<QuizCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      List<String> roundIds = List<String>();
      if (widget.intialRound != null) {
        roundIds.add(widget.intialRound.id);
      }
      try {
        _quiz.roundIds = roundIds;
        String newDocId = await quizService.addQuizToFirebaseCollection(
          _quiz,
          userModel.uid,
        );
        userModel.quizIds.add(newDocId);
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
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
                  Text(widget.intialRound != null
                      ? "Quiz will be created with: \n${widget.intialRound?.title} \n\n"
                      : ""),
                  ButtonPrimary(
                    text: "Create",
                    isLoading: _isLoading,
                    onPressed: _onSubmit,
                  ),
                  FormError(error: _error),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
