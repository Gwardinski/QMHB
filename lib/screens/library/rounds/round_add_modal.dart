import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RoundAddModal extends StatefulWidget {
  final QuestionModel initialQuestion;

  RoundAddModal({
    this.initialQuestion,
  });
  @override
  _RoundAddModalState createState() => _RoundAddModalState();
}

class _RoundAddModalState extends State<RoundAddModal> {
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
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                widget.initialQuestion != null
                    ? Text("Round will be created with: \n${widget.initialQuestion?.question} \n\n")
                    : Container(),
                FormInput(
                  initialValue: _round.title,
                  validate: validateForm,
                  labelText: "Round Name",
                  noPadding: true,
                  onChanged: (val) {
                    setState(() {
                      _round.title = val;
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
