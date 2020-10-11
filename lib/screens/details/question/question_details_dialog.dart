import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/questions/add_question_to_round_dialog.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

import '../../../get_it.dart';

class QuestionDetailsDialog extends StatefulWidget {
  const QuestionDetailsDialog({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  final QuestionModel questionModel;

  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class _QuestionDetailsState extends State<QuestionDetailsDialog> {
  bool _revealAnswer = false;

  void _updateRevealAnswer() {
    setState(() {
      _revealAnswer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: 440,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        widget.questionModel.question,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    widget.questionModel.imageURL != null
                        ? ImageSwitcher(
                            networkImage: widget.questionModel.imageURL,
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    _revealAnswer
                        ? Container(
                            height: getIt<AppSize>().spacingXl,
                            child: Center(
                              child: Text(
                                widget.questionModel.answer,
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          )
                        : ButtonText(
                            text: 'Reveal Answer',
                            onTap: () {
                              _updateRevealAnswer();
                            },
                            type: ButtonTextType.PRIMARY,
                          ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    InfoColumn(
                      title: 'Points',
                      value: widget.questionModel.points.toString(),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    InfoColumn(
                      title: 'Category',
                      value: widget.questionModel.category,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoColumn(
                          title: 'Created',
                          value: DateFormat('dd-mm-yyyy').format(widget.questionModel.createdAt),
                        ),
                        InfoColumn(
                          title: 'Updated',
                          value: DateFormat('dd-mm-yyyy').format(widget.questionModel.lastUpdated),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16))
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: const Text('Add To Round'),
                  onPressed: () {
                    Navigator.pop(context);
                    _addQuestionToRound();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _addQuestionToRound() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AddQuestionToRoundPageDialog(
          questionModel: widget.questionModel,
        );
      },
    );
  }
}
