import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RoundDetailsEditor extends StatefulWidget {
  final RoundModel round;
  final bool isNewRound;
  final Function(RoundModel) onRoundUpdate;
  final GlobalKey<FormState> formkey;

  RoundDetailsEditor({
    @required this.round,
    @required this.isNewRound,
    @required this.onRoundUpdate,
    @required this.formkey,
  });

  @override
  _RoundDetailsEditorState createState() => _RoundDetailsEditorState();
}

class _RoundDetailsEditorState extends State<RoundDetailsEditor>
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
                initialValue: widget.round.title,
                validate: validateForm,
                labelText: "Title",
                onChanged: (val) {
                  widget.round.title = val;
                  widget.onRoundUpdate(widget.round);
                },
              ),
              FormInput(
                initialValue: widget.round.description,
                validate: validateForm,
                keyboardType: TextInputType.multiline,
                labelText: "Description",
                onChanged: (val) {
                  widget.round.description = val;
                  widget.onRoundUpdate(widget.round);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
