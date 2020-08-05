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
  bool _isLoading = false;
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
    return Container(
      constraints: BoxConstraints(maxWidth: 600),
      padding: EdgeInsets.all(16),
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
      QuestionModel questionModel = QuestionModel(
        question: _question,
        answer: _answer,
        points: _points,
        category: _category,
        isPublished: false,
      );
      widget.onSubmit(questionModel);
    }
  }
}
