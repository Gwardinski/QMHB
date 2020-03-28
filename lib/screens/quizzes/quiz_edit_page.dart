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

class QuizEditPage extends StatefulWidget {
  final QuizModel quizModel;

  QuizEditPage({this.quizModel});
  @override
  _QuizEditPageState createState() => _QuizEditPageState();
}

class _QuizEditPageState extends State<QuizEditPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _title = '';
  String _description = '';

  @override
  void initState() {
    super.initState();
    _title = widget.quizModel.title;
    _description = widget.quizModel.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Quiz Details"),
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
      QuizModel newQuizModel = QuizModel(
        uid: widget.quizModel.uid,
        title: _title,
        description: _description,
        isPublished: false,
      );
      try {
        await databaseService.editQuizOnFirebase(newQuizModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
