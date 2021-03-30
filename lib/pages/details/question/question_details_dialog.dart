import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/library/add_question_to_rounds_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/shared/widgets/button_text.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

import '../../../get_it.dart';

class QuestionDetailsDialog extends StatefulWidget {
  const QuestionDetailsDialog({
    Key key,
    @required this.question,
  }) : super(key: key);

  final QuestionModel question;

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
                        widget.question.question,
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    widget.question.imageUrl != null
                        ? ImageSwitcher(
                            networkImage: widget.question.imageUrl,
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    _revealAnswer
                        ? Container(
                            height: getIt<AppSize>().spacingXl,
                            child: Center(
                              child: Text(
                                widget.question.answer,
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
                      value: widget.question.points.toString(),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    InfoColumn(
                      title: 'Category',
                      value: widget.question.category,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 16)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoColumn(
                          title: 'Created',
                          value: widget.question.createdAt != null
                              ? DateFormat('d-MM-yy').format(widget.question.createdAt)
                              : "No Date",
                        ),
                        InfoColumn(
                          title: 'Updated',
                          value: widget.question.lastUpdated != null
                              ? DateFormat('d-MM-yy').format(widget.question.lastUpdated)
                              : "No Date",
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
                TextButton(
                  child: Text('Add To Round'),
                  onPressed: () {
                    Provider.of<NavigationService>(context, listen: false).pop();
                    _addQuestionToRounds();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _addQuestionToRounds() {
    Provider.of<NavigationService>(context, listen: false).push(
      AddQuestionToRoundsPage(
        selectedQuestion: widget.question,
      ),
    );
  }
}
