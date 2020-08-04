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

enum QuestionEditorPageType {
  ADD,
  EDIT,
}

class QuestionEditorPage extends StatefulWidget {
  final QuestionEditorPageType type;
  final QuestionModel questionModel;

  QuestionEditorPage({
    @required this.type,
    this.questionModel,
  });
  @override
  _QuestionEditorPageState createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<QuestionEditorPage> {
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
    if (widget.questionModel != null) {
      _question = widget.questionModel.question;
      _answer = widget.questionModel.answer;
      _category = widget.questionModel.category;
      _points = widget.questionModel.points;
    } else {
      _category = acceptedCategories[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == QuestionEditorPageType.ADD ? "Create Question" : "Edit Question",
        ),
        actions: widget.type == QuestionEditorPageType.EDIT
            ? [
                FlatButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  onPressed: () {
                    _asyncConfirmDialog();
                  },
                ),
              ]
            : [],
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
                  keyboardType: TextInputType.multiline,
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
                  keyboardType: TextInputType.multiline,
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
                  onPressed:
                      widget.type == QuestionEditorPageType.ADD ? _createQuestion : _editQuestion,
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

  _editQuestion() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final databaseService = Provider.of<DatabaseService>(context);
      final user = Provider.of<UserDataStateModel>(context).user;
      QuestionModel newQuestionModel = QuestionModel(
        uid: widget.questionModel.uid,
        question: _question,
        answer: _answer,
        points: _points,
        category: _category,
        isPublished: false,
      );
      try {
        await databaseService.editQuestionOnFirebase(newQuestionModel, user);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Question');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  Future _asyncConfirmDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Question'),
          content: const Text('Are you sure you wish to delete your question?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await _deleteQuestion();
              },
            )
          ],
        );
      },
    );
  }

  _deleteQuestion() async {
    final user = Provider.of<UserDataStateModel>(context).user;
    final databaseService = Provider.of<DatabaseService>(context);
    await databaseService.deleteQuestion(user, widget.questionModel);
  }
}
