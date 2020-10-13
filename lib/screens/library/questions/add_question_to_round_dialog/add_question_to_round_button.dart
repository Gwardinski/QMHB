import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/services/round_collection_service.dart';

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
  RoundCollectionService roundCollectionService;

  @override
  void initState() {
    super.initState();
    roundModel = widget.roundModel;
    questionModel = widget.questionModel;
    roundCollectionService = Provider.of<RoundCollectionService>(context, listen: false);
  }

  bool _containsQuestion() {
    return roundModel.questionIds.contains(questionModel.id);
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
          await roundCollectionService.addQuestionToRound(roundModel, questionModel);
        } else {
          await roundCollectionService.removeQuestionFromRound(roundModel, questionModel);
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
                  roundModel.title,
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
                        _containsQuestion()
                            ? Icons.check_box
                            : Icons.check_box_outline_blank_outlined,
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
