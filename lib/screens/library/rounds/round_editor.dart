import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RoundEditor extends StatefulWidget {
  final RoundModel roundModel;

  RoundEditor({
    this.roundModel,
  });
  @override
  _RoundEditorState createState() => _RoundEditorState();
}

class _RoundEditorState extends State<RoundEditor> {
  final _formKey = GlobalKey<FormState>();
  RoundModel _round;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    _round = widget.roundModel;
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
      _editRound();
    }
  }

  _editRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final roundService = Provider.of<RoundCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      try {
        await roundService.editRoundOnFirebaseCollection(
          _round,
        );
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Round');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          padding: EdgeInsets.fromLTRB(
            16,
            MediaQuery.of(context).size.width > 800 ? 128 : 16,
            16,
            16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormInput(
                  initialValue: _round.title,
                  validate: validateForm,
                  labelText: "Title",
                  onChanged: (val) {
                    setState(() {
                      _round.title = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _round.description,
                  validate: validateForm,
                  keyboardType: TextInputType.multiline,
                  labelText: "Description",
                  onChanged: (val) {
                    setState(() {
                      _round.description = val;
                    });
                  },
                ),
                ButtonPrimary(
                  text: "Submit",
                  isLoading: _isLoading,
                  onPressed: _onSubmit,
                ),
                FormError(error: _error),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
