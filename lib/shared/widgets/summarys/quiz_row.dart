import 'package:flutter/material.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/shared/widgets/summarys/summary_content.dart';
import 'package:qmhb/shared/widgets/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';

class QuizRow extends StatelessWidget {
  const QuizRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          title: "Quizzes",
          buttonText: "See All",
          buttonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizzesScreen(),
              ),
            );
          },
        ),
        SummaryContentList(),
        SummaryRowFooter(),
      ],
    );
  }
}
