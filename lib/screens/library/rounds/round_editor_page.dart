import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

enum RoundEditorPageType {
  ADD,
  EDIT,
}

class RoundEditorPage extends StatefulWidget {
  final RoundEditorPageType type;
  final String initialQuestionId;
  final RoundModel roundModel;

  RoundEditorPage({
    @required this.type,
    this.initialQuestionId,
    this.roundModel,
  });
  @override
  _RoundEditorPageState createState() => _RoundEditorPageState();
}

class _RoundEditorPageState extends State<RoundEditorPage> {
  bool _isLoading = false;
  String _error = '';
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    if (widget.roundModel != null) {
      _title = widget.roundModel.title;
      _description = widget.roundModel.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.type == RoundEditorPageType.ADD ? "Create Round" : "Edit Round"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getIt<AppSize>().rSpacingMd),
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
                  text: "Submit",
                  isLoading: _isLoading,
                  onPressed: widget.type == RoundEditorPageType.ADD ? _createRound : _editRound,
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

  _editRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      RoundModel newRoundModel = widget.roundModel;
      newRoundModel.title = _title;
      newRoundModel.description = _description;
      try {
        await databaseService.editRoundOnFirebase(newRoundModel, user);
        Navigator.of(context).pop(newRoundModel);
      } catch (e) {
        print(e);
        _updateError('Failed to edit Round');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
