import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/form/category_selector.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class QuestionDetailsEditor extends StatefulWidget {
  final QuestionModel question;
  final bool isNewQuestion;
  final Function(QuestionModel) onQuestionUpdate;
  final GlobalKey<FormState> formkey;

  QuestionDetailsEditor({
    @required this.question,
    @required this.isNewQuestion,
    @required this.onQuestionUpdate,
    @required this.formkey,
  });

  @override
  _QuestionDetailsEditorState createState() => _QuestionDetailsEditorState();
}

class _QuestionDetailsEditorState extends State<QuestionDetailsEditor>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(isLandscape ? 64 : 16),
        child: Form(
          key: widget.formkey,
          child: Column(
            children: <Widget>[
              FormInput(
                initialValue: widget.question.question,
                validate: validateForm,
                labelText: "Question",
                keyboardType: TextInputType.multiline,
                onChanged: (val) {
                  widget.question.question = val;
                  widget.onQuestionUpdate(widget.question);
                },
              ),
              FormInput(
                initialValue: widget.question.answer,
                validate: validateForm,
                labelText: "Answer",
                keyboardType: TextInputType.multiline,
                onChanged: (val) {
                  widget.question.answer = val;
                  widget.onQuestionUpdate(widget.question);
                },
              ),
              FormInput(
                initialValue: widget.question.points.toString(),
                validate: validateNumber,
                keyboardType: TextInputType.number,
                labelText: "Points",
                onChanged: (val) {
                  widget.question.points = double.tryParse(val) ?? 0;
                  widget.onQuestionUpdate(widget.question);
                },
              ),
              CategorySelector(
                initialValue: widget.question.category,
                onSelect: (val) {
                  widget.question.category = val;
                  widget.onQuestionUpdate(widget.question);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
