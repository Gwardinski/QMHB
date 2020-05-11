import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

enum QuizEditorPageType {
  ADD,
  EDIT,
}

class QuizEditorPage extends StatefulWidget {
  final QuizEditorPageType type;
  final String initialRoundId;
  final QuizModel quizModel;

  QuizEditorPage({
    @required this.type,
    this.initialRoundId,
    this.quizModel,
  });
  @override
  _QuizEditorPageState createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    if (widget.quizModel != null) {
      _title = widget.quizModel.title;
      _description = widget.quizModel.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == QuizEditorPageType.ADD ? "Create Quiz" : "Edit Quiz"),
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
                  onPressed: widget.type == QuizEditorPageType.ADD ? _createQuiz : _editQuiz,
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

  _createQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      List<String> roundIds = List<String>();
      if (widget.initialRoundId != null) {
        roundIds.add(widget.initialRoundId);
      }
      QuizModel quizModel = QuizModel(
        title: _title,
        description: _description,
        roundIds: roundIds,
        isPublished: false,
      );
      try {
        await databaseService.addQuizToFirebase(quizModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  _editQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      QuizModel newQuizModel = widget.quizModel;
      newQuizModel.title = _title;
      newQuizModel.description = _description;
      try {
        await databaseService.editQuizOnFirebase(newQuizModel, user);
        Navigator.of(context).pop(newQuizModel);
      } catch (e) {
        print(e);
        _updateError('Failed to edit Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
