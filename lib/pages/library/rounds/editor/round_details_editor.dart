import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/pages/library/widgets/editor_header.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/form/image_selector.dart';

class RoundDetailsEditor extends StatelessWidget {
  final RoundModel round;
  final Function(RoundModel) onRoundUpdate;
  final GlobalKey<FormState> formkey;

  RoundDetailsEditor({
    @required this.round,
    @required this.onRoundUpdate,
    @required this.formkey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorHeader(
          title: "Round Details",
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
                      networkImage: round.imageUrl,
                      selectImage: () {},
                      removeImage: () {},
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(left: 32)),
                Column(
                  children: [
                    FormInput(
                      initialValue: round.title,
                      validate: validateForm,
                      labelText: "Title",
                      onChanged: (val) {
                        round.title = val;
                        onRoundUpdate(round);
                      },
                    ),
                    FormInput(
                      initialValue: round.description,
                      validate: validateForm,
                      keyboardType: TextInputType.multiline,
                      labelText: "Description",
                      onChanged: (val) {
                        round.description = val;
                        onRoundUpdate(round);
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
