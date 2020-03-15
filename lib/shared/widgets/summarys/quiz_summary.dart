import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/star_rating.dart';

class QuizSummary extends StatelessWidget {
  const QuizSummary({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: 120,
      color: Color(0xff6D6D6D),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text("Quiz Name")),
            Column(
              children: <Widget>[
                Text("Difficulty"),
                StarRatingRow(
                  rating: 4,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text("Rounds"),
                Text(
                  "5",
                  style: TextStyle(
                    color: Color(0xffFFA630),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
