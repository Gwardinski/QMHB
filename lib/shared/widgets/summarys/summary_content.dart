import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/summarys/quiz_summary.dart';

class SummaryContentList extends StatelessWidget {
  const SummaryContentList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.separated(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        itemBuilder: (BuildContext context, int index) {
          EdgeInsets padding = index == 0
              ? EdgeInsets.only(left: 16)
              : index == (10 - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
          return Padding(
            padding: padding,
            child: QuizSummary(),
          );
        },
      ),
    );
  }
}
