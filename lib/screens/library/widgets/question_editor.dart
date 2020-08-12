import 'package:flutter/material.dart';
import 'package:qmhb/models/category_model.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_dropdown.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class QuestionEditor extends StatefulWidget {
  final QuestionModel questionModel;
  final onSubmit;

  QuestionEditor({
    this.questionModel,
    this.onSubmit,
  });
  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  final _formKey = GlobalKey<FormState>();
  QuestionModel _questionEdit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.questionModel != null) {
      _questionEdit = widget.questionModel;
    } else {
      _questionEdit.category = acceptedCategories[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            FormInput(
              initialValue: _questionEdit.question,
              validate: validateForm,
              labelText: "Question",
              keyboardType: TextInputType.multiline,
              onChanged: (val) {
                setState(() {
                  _questionEdit.question = val;
                });
              },
            ),
            FormInput(
              initialValue: _questionEdit.answer,
              validate: validateForm,
              labelText: "Answer",
              keyboardType: TextInputType.multiline,
              onChanged: (val) {
                setState(() {
                  _questionEdit.answer = val;
                });
              },
            ),
            FormInput(
              initialValue: _questionEdit.points.toString(),
              validate: validateNumber,
              keyboardType: TextInputType.number,
              labelText: "Points",
              onChanged: (val) {
                setState(() {
                  _questionEdit.points = double.parse(val);
                });
              },
            ),
            FormDropdown(
              initialValue: _questionEdit.category,
              onSelect: (val) {
                setState(() {
                  _questionEdit.category = val;
                });
              },
            ),
            ButtonPrimary(
              text: "Submit",
              isLoading: _isLoading,
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      widget.onSubmit(_questionEdit);
    }
  }
}
