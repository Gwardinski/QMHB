import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
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
  final PageController _controller = PageController(initialPage: 0);

  void _updateRevealAnswer() {
    setState(() => _revealAnswer = true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 16),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Details'),
          onPressed: () => _controller.jumpToPage(1),
        ),
      ],
      content: Container(
        height: 400,
        width: 400,
        child: PageView(
          controller: _controller,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        onTap: () => _updateRevealAnswer(),
                        type: ButtonTextType.PRIMARY,
                      ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
