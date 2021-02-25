import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/widgets/add_to_dialog_button.dart';
import 'package:qmhb/services/quiz_service.dart';

class AddRoundToQuizButton extends StatefulWidget {
  const AddRoundToQuizButton({
    Key key,
    @required this.quizModel,
    @required this.roundModel,
  }) : super(key: key);

  final QuizModel quizModel;
  final RoundModel roundModel;

  @override
  _AddRoundToQuizButtonState createState() => _AddRoundToQuizButtonState();
}

class _AddRoundToQuizButtonState extends State<AddRoundToQuizButton> {
  bool _isLoading = false;
  QuizModel quizModel;
  RoundModel roundModel;
  QuizService quizService;

  @override
  void initState() {
    super.initState();
    quizModel = widget.quizModel;
    roundModel = widget.roundModel;
    quizService = Provider.of<QuizService>(context, listen: false);
  }

  bool _containsRound() {
    return quizModel.rounds.contains(roundModel);
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
        if (!_containsRound()) {
          await quizService.addRoundToQuiz(quizModel, roundModel);
        } else {
          await quizService.removeRoundFromQuiz(quizModel, roundModel);
        }
        _setLoading(false);
      },
      child: AddToDialogButton(
        title: roundModel.title,
        isLoading: _isLoading,
        contains: _containsRound,
      ),
    );
  }
}
