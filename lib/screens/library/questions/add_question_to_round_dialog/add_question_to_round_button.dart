import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/widgets/add_to_dialog_button.dart';
import 'package:qmhb/services/round_service.dart';

class AddQuestionToRoundButton extends StatefulWidget {
  const AddQuestionToRoundButton({
    Key key,
    @required this.roundModel,
    @required this.questionModel,
  }) : super(key: key);

  final RoundModel roundModel;
  final QuestionModel questionModel;

  @override
  _AddQuestionToRoundButtonState createState() => _AddQuestionToRoundButtonState();
}

class _AddQuestionToRoundButtonState extends State<AddQuestionToRoundButton> {
  bool _isLoading = false;
  RoundModel roundModel;
  QuestionModel questionModel;
  RoundService roundService;

  @override
  void initState() {
    super.initState();
    roundModel = widget.roundModel;
    questionModel = widget.questionModel;
    roundService = Provider.of<RoundService>(context, listen: false);
  }

  bool _containsQuestion() {
    return roundModel.questions.contains(questionModel);
  }

  _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _setLoading(true);
        if (!_containsQuestion()) {
          await roundService.addQuestionToRound(roundModel, questionModel);
        } else {
          await roundService.removeQuestionFromRound(roundModel, questionModel);
        }
        _setLoading(false);
      },
      child: AddToDialogButton(
        title: roundModel.title,
        isLoading: _isLoading,
        contains: _containsQuestion,
      ),
    );
  }
}
