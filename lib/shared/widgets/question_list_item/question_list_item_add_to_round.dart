import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/round_service.dart';

class QuestionListItemActionAddToRound extends StatefulWidget {
  QuestionListItemActionAddToRound({
    Key key,
    @required this.roundModel,
    @required this.questionModel,
  }) : super(key: key);

  final RoundModel roundModel;
  final QuestionModel questionModel;

  @override
  _QuestionListItemActionAddToRoundState createState() => _QuestionListItemActionAddToRoundState();
}

class _QuestionListItemActionAddToRoundState extends State<QuestionListItemActionAddToRound> {
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: 64,
      height: 64,
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: _isLoading
                    ? Container(height: 24, width: 24, child: CircularProgressIndicator())
                    : Icon(
                        _containsQuestion() ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 24,
                      ),
              ),
            ],
          ),
        ),
        onPressed: () async {
          _setLoading(true);
          if (!_containsQuestion()) {
            await roundService.addQuestionToRound(roundModel, questionModel);
          } else {
            await roundService.removeQuestionFromRound(roundModel, questionModel);
          }
          _setLoading(false);
        },
      ),
    );
  }
}
