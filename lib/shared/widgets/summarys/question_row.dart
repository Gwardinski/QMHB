import 'package:flutter/material.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/shared/widgets/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';

class QuestionRow extends StatelessWidget {
  const QuestionRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SummaryRowHeader(
          title: "Questions",
          buttonText: "See All",
          buttonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizzesScreen(),
              ),
            );
          },
        ),
        Container(
          height: 120,
          child: ListView.separated(
            itemCount: 10,
            scrollDirection: Axis.vertical,
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            itemBuilder: (BuildContext context, int index) {
              EdgeInsets padding = index == 0
                  ? EdgeInsets.only(left: 16)
                  : index == (10 - 1) ? EdgeInsets.only(right: 16) : EdgeInsets.all(0);
              return Padding(
                padding: padding,
                child: Container(),
              );
            },
          ),
        ),
        SummaryRowFooter(),
      ],
    );
  }
}
