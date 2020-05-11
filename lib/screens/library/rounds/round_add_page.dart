import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundAddPage extends StatefulWidget {
  final initialQuestionId;

  RoundAddPage({
    this.initialQuestionId,
  });
  @override
  _RoundAddPageState createState() => _RoundAddPageState();
}

class _RoundAddPageState extends State<RoundAddPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Round"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormInput(
                  initialValue: _title,
                  validate: validateForm,
                  labelText: "Title",
                  onChanged: (val) {
                    setState(() {
                      _title = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _description,
                  validate: validateForm,
                  keyboardType: TextInputType.multiline,
                  labelText: "Description",
                  onChanged: (val) {
                    setState(() {
                      _description = val;
                    });
                  },
                ),
                ButtonPrimary(
                  child: _isLoading ? LoadingSpinnerHourGlass() : Text("Submit"),
                  onPressed: _createRound,
                ),
                FormError(error: _error),
              ],
            ),
          ),
        ),
      ),
    );
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

  _createRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      List<String> questionIds = List<String>();
      if (widget.initialQuestionId != null) {
        questionIds.add(widget.initialQuestionId);
      }
      RoundModel roundModel = RoundModel(
        title: _title,
        description: _description,
        questionIds: questionIds,
        isPublished: false,
      );
      try {
        await databaseService.addRoundToFirebase(roundModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Round');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
