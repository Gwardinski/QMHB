import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/pages/library/widgets/editor_header.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/form/image_selector.dart';

class QuizDetailsEditor extends StatelessWidget {
  final QuizModel quiz;
  final Function(QuizModel) onQuizUpdate;
  final GlobalKey<FormState> formkey;

  QuizDetailsEditor({
    @required this.quiz,
    @required this.onQuizUpdate,
    @required this.formkey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorHeader(
          title: "Quiz Details",
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formkey,
            child: Wrap(
              children: <Widget>[
                Column(
                  children: [
                    ImageSelector(
                      fileImage: null,
                      networkImage: quiz.imageUrl,
                      selectImage: () {},
                      removeImage: () {},
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 32)),
                Column(
                  children: [
                    FormInput(
                      initialValue: quiz.title,
                      validate: validateForm,
                      labelText: "Title",
                      onChanged: (val) {
                        quiz.title = val;
                        onQuizUpdate(quiz);
                      },
                    ),
                    FormInput(
                      initialValue: quiz.description,
                      validate: validateForm,
                      keyboardType: TextInputType.multiline,
                      labelText: "Description",
                      onChanged: (val) {
                        quiz.description = val;
                        onQuizUpdate(quiz);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
