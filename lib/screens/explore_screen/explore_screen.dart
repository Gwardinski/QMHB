import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/screens/questions/questions_page.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/screens/rounds/rounds_page.dart';
import 'package:qmhb/shared/widgets/summarys/question_row.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 8)),
                // QuizRow(
                //   headerTitle: "Featured Quizzes",
                //   headerButtonText: "Search All Quizzes",
                //   headerButtonFunction: () {
                //     // Navigator.of(context).push(
                //     //   MaterialPageRoute(
                //     //     builder: (context) => QuizzesScreen(),
                //     //   ),
                //     // );
                //   },
                // ),
                // RoundRow(
                //   headerTitle: "Featured Rounds",
                //   headerButtonText: "Search All Rounds",
                //   headerButtonFunction: () {
                //     // Navigator.of(context).push(
                //     //   MaterialPageRoute(
                //     //     builder: (context) => RoundsScreen(),
                //     //   ),
                //     // );
                //   },
                // ),
                // QuestionRow(
                //   headerTitle: "Featured Questions",
                //   headerButtonText: "Search All Questions",
                //   headerButtonFunction: () {
                //     // Navigator.of(context).push(
                //     //   MaterialPageRoute(
                //     //     builder: (context) => QuestionsScreen(),
                //     //   ),
                //     // );
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
