import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RoundAdd extends StatefulWidget {
  final QuestionModel initialQuestion;

  RoundAdd({
    this.initialQuestion,
  });
  @override
  _RoundAddState createState() => _RoundAddState();
}

class _RoundAddState extends State<RoundAdd> {
  final _formKey = GlobalKey<FormState>();
  RoundModel _round;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _round = RoundModel.newRound();
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
      _createRound();
    }
  }

  _createRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final roundService = Provider.of<RoundCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      List<String> questionIds = List<String>();
      if (widget.initialQuestion != null) {
        questionIds.add(widget.initialQuestion.id);
      }
      try {
        _round.questionIds = questionIds;
        String newDocId = await roundService.addRoundToFirebaseCollection(
          _round,
          userModel.uid,
        );
        userModel.roundIds.add(newDocId);
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Round');
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
                    initialValue: _round.title,
                    validate: validateForm,
                    labelText: "Round Name",
                    onChanged: (val) {
                      setState(() {
                        _round.title = val;
                      });
                    },
                  ),
                  Text(widget.initialQuestion != null
                      ? "round will be created with: \n${widget.initialQuestion?.question} \n\n"
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
