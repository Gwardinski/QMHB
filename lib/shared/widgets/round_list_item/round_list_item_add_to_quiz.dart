import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class RoundListItemActionAddToQuiz extends StatefulWidget {
  RoundListItemActionAddToQuiz({
    Key key,
    @required this.quizModel,
    @required this.roundModel,
  }) : super(key: key);

  final QuizModel quizModel;
  final RoundModel roundModel;

  @override
  _QuestionListItemActionAddToRoundState createState() => _QuestionListItemActionAddToRoundState();
}

class _QuestionListItemActionAddToRoundState extends State<RoundListItemActionAddToQuiz> {
  bool _isLoading = false;
  QuizModel quizModel;
  RoundModel roundModel;
  QuizCollectionService quizCollectionService;

  @override
  void initState() {
    super.initState();
    quizModel = widget.quizModel;
    roundModel = widget.roundModel;
    quizCollectionService = Provider.of<QuizCollectionService>(context, listen: false);
  }

  bool _containsRound() {
    print(quizModel.toString());
    return quizModel.roundIds.contains(roundModel.id);
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
                    ? Container(height: 40, width: 40, child: LoadingSpinnerHourGlass())
                    : Icon(
                        _containsRound() ? Icons.remove_circle_outline : Icons.add_to_queue,
                        size: 24,
                      ),
              ),
            ],
          ),
        ),
        onPressed: () async {
          _setLoading(true);
          if (!_containsRound()) {
            await quizCollectionService.addRoundToQuiz(quizModel, roundModel);
          } else {
            await quizCollectionService.removeRoundFromQuiz(quizModel, roundModel);
          }
          _setLoading(false);
        },
      ),
    );
  }
}
