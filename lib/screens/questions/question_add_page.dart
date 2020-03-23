import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/category_model.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_dropdown.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class QuestionAddPage extends StatefulWidget {
  QuestionAddPage();
  @override
  _QuestionAddPageState createState() => _QuestionAddPageState();
}

class _QuestionAddPageState extends State<QuestionAddPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _question = '';
  String _answer = '';
  String _category;
  double _points = 1;

  @override
  void initState() {
    super.initState();
    _category = acceptedCategories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Question"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormInput(
                  initialValue: _question,
                  validate: validateForm,
                  labelText: "Question",
                  onChanged: (val) {
                    setState(() {
                      _question = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _answer,
                  validate: validateForm,
                  labelText: "Answer",
                  onChanged: (val) {
                    setState(() {
                      _answer = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _points.toString(),
                  validate: validateNumber,
                  keyboardType: TextInputType.number,
                  labelText: "Points",
                  onChanged: (val) {
                    setState(() {
                      _points = double.parse(val);
                    });
                  },
                ),
                FormDropdown(
                  initialValue: _category,
                  onSelect: (val) {
                    setState(() {
                      _category = val;
                    });
                  },
                ),
                ButtonPrimary(
                  child: _isLoading ? LoadingSpinnerHourGlass() : Text("Submit"),
                  onPressed: _createQuestion,
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

  _createQuestion() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      QuestionModel questionModel = QuestionModel(
        question: _question,
        answer: _answer,
        points: _points,
        category: _category,
        isPublished: false,
      );
      try {
        await databaseService.addQuestionToFirebase(questionModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Question');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
