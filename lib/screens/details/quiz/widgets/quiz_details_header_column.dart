import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/details/info_column.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';

import '../../../../get_it.dart';

class QuizDetailsHeaderColumn extends StatefulWidget {
  const QuizDetailsHeaderColumn({
    Key key,
    this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  _QuizDetailsHeaderColumnState createState() => _QuizDetailsHeaderColumnState();
}

class _QuizDetailsHeaderColumnState extends State<QuizDetailsHeaderColumn> {
  bool isExpanded = false;

  expandImage(bool expand) {
    setState(() {
      isExpanded = expand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (widget.quizModel.imageURL != null)
            ? GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0)
                    expandImage(true);
                  else
                    expandImage(false);
                },
                onTap: () {
                  expandImage(true);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  width: double.infinity,
                  height: isExpanded ? 300 : 120,
                  margin: EdgeInsets.only(bottom: 32),
                  child: ImageSwitcher(
                    fileImage: null,
                    networkImage: widget.quizModel.imageURL,
                  ),
                ),
              )
            : Container(height: 32),
        Text(
          "Quiz",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        Text(
          widget.quizModel.title,
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: getIt<AppSize>().spacingLg)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InfoColumn(title: "Rounds", value: widget.quizModel.roundIds.length.toString()),
            InfoColumn(title: "Points", value: widget.quizModel.totalPoints.toString()),
            InfoColumn(
              title: "Created",
              value: DateFormat('dd-mm-yyyy').format(widget.quizModel.createdAt),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            getIt<AppSize>().spacingLg,
          ),
          child: Text(
            widget.quizModel.description ?? 'no description',
            style: TextStyle(
              fontSize: 16,
              fontStyle: widget.quizModel.description != null ? FontStyle.normal : FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
