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

class RoundEditPage extends StatefulWidget {
  final RoundModel roundModel;

  RoundEditPage({this.roundModel});
  @override
  _RoundEditPageState createState() => _RoundEditPageState();
}

class _RoundEditPageState extends State<RoundEditPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _title = widget.roundModel.title;
    _description = widget.roundModel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Round Details"),
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
                  labelText: "Description",
                  keyboardType: TextInputType.multiline,
                  onChanged: (val) {
                    setState(() {
                      _description = val;
                    });
                  },
                ),
                ButtonPrimary(
                  child: _isLoading ? LoadingSpinnerHourGlass() : Text("Submit"),
                  onPressed: _editQuestion,
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

  _editQuestion() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      RoundModel newRoundModel = RoundModel(
        uid: widget.roundModel.uid,
        title: _title,
        description: _description,
        isPublished: false,
      );
      try {
        await databaseService.editRoundOnFirebase(newRoundModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Round');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
