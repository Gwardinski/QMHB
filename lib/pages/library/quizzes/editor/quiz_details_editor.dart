import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class QuizDetailsEditor extends StatefulWidget {
  final QuizModel quiz;
  final bool isNewQuiz;
  final Function(QuizModel) onQuizUpdate;
  final GlobalKey<FormState> formkey;

  QuizDetailsEditor({
    @required this.quiz,
    @required this.isNewQuiz,
    @required this.onQuizUpdate,
    @required this.formkey,
  });

  @override
  _QuizDetailsEditorState createState() => _QuizDetailsEditorState();
}

class _QuizDetailsEditorState extends State<QuizDetailsEditor> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(isLandscape ? 32 : 16),
        child: Form(
          key: widget.formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormInput(
                initialValue: widget.quiz.title,
                validate: validateForm,
                labelText: "Title",
                onChanged: (val) {
                  widget.quiz.title = val;
                  widget.onQuizUpdate(widget.quiz);
                },
              ),
              FormInput(
                initialValue: widget.quiz.description,
                validate: validateForm,
                keyboardType: TextInputType.multiline,
                labelText: "Description",
                onChanged: (val) {
                  widget.quiz.description = val;
                  widget.onQuizUpdate(widget.quiz);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
