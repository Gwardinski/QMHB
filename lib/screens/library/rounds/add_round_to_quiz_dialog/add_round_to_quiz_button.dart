import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/quiz_collection_service.dart';

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
  QuizCollectionService quizCollectionService;

  @override
  void initState() {
    super.initState();
    quizModel = widget.quizModel;
    roundModel = widget.roundModel;
    quizCollectionService = Provider.of<QuizCollectionService>(context, listen: false);
  }

  bool _containsRound() {
    return quizModel.roundIds.contains(roundModel.id);
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
          await quizCollectionService.addRoundToQuiz(quizModel, roundModel);
        } else {
          await quizCollectionService.removeRoundFromQuiz(quizModel, roundModel);
        }
        _setLoading(false);
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.roundModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                _isLoading
                    ? Container(height: 24, width: 24, child: CircularProgressIndicator())
                    : Icon(
                        _containsRound() ? Icons.check_box : Icons.check_box_outline_blank_outlined,
                        size: 24,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
