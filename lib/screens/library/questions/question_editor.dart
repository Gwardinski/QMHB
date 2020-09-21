import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/category_selector.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

import '../../../get_it.dart';

enum QuestionEditorType {
  ADD,
  EDIT,
}

class QuestionEditor extends StatefulWidget {
  final QuestionModel questionModel;
  final QuestionEditorType type;

  QuestionEditor({
    this.questionModel,
    this.type,
  });
  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  final _formKey = GlobalKey<FormState>();
  QuestionModel _question;
  bool _isLoading = false;
  String _error = "";

  @override
  void initState() {
    super.initState();
    if (widget.questionModel != null) {
      _question = widget.questionModel;
    } else {
      _question = QuestionModel.newQuestion();
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
      widget.type == QuestionEditorType.ADD ? _createQuestion() : _editQuestion();
    }
  }

  _createQuestion() async {
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      _updateIsLoading(true);
      _updateError('');
      String newDocId = await questionService.addQuestionToFirebaseCollection(
        _question,
        userModel.uid,
      );
      userModel.questionIds.add(newDocId);
      await userService.updateUserDataOnFirebase(userModel);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      _updateError('Failed to edit Question');
    } finally {
      _updateIsLoading(false);
    }
  }

  _editQuestion() async {
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      _updateIsLoading(true);
      _updateError('');
      await questionService.editQuestionOnFirebaseCollection(
        _question,
      );
      await userService.updateUserDataOnFirebase(userModel);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      _updateError('Failed to edit Question');
    } finally {
      _updateIsLoading(false);
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
            getIt<AppSize>().isLarge ? 128 : 16,
            16,
            16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormInput(
                  initialValue: _question.question,
                  validate: validateForm,
                  labelText: "Question",
                  keyboardType: TextInputType.multiline,
                  onChanged: (val) {
                    setState(() {
                      _question.question = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _question.answer,
                  validate: validateForm,
                  labelText: "Answer",
                  keyboardType: TextInputType.multiline,
                  onChanged: (val) {
                    setState(() {
                      _question.answer = val;
                    });
                  },
                ),
                FormInput(
                  initialValue: _question.points.toString(),
                  validate: validateNumber,
                  keyboardType: TextInputType.number,
                  labelText: "Points",
                  onChanged: (val) {
                    setState(() {
                      _question.points = double.parse(val);
                    });
                  },
                ),
                CategorySelector(
                  initialValue: _question.category,
                  onSelect: (val) {
                    setState(() {
                      _question.category = val;
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
