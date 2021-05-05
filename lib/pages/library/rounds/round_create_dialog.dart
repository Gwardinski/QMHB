import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RoundCreateDialog extends StatefulWidget {
  final QuestionModel initialQuestion;

  RoundCreateDialog({
    this.initialQuestion,
  });
  @override
  _RoundAddModalState createState() => _RoundAddModalState();
}

class _RoundAddModalState extends State<RoundCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  RoundModel _round;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _round = RoundModel(title: "");
    if (widget.initialQuestion != null) {
      _round.questions = [widget.initialQuestion.id];
      _round.totalPoints = widget.initialQuestion.points;
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
      _createRound();
    }
  }

  _createRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final token = Provider.of<UserDataStateModel>(context, listen: false).token;
      final roundService = Provider.of<RoundService>(context, listen: false);
      final refreshService = Provider.of<RefreshService>(context, listen: false);
      try {
        await roundService.createRound(
          round: _round,
          token: token,
        );
        refreshService.roundAndQuestionRefresh();
        Provider.of<NavigationService>(context, listen: false).pop();
      } catch (e) {
        print(e);
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.initialQuestion != null
                    ? Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "Round will be created with:",
                            ),
                            Text(
                              "\n\"${widget.initialQuestion?.question}\"\n",
                            ),
                          ],
                        ),
                      )
                    : Container(),
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
