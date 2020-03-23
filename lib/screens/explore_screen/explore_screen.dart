import 'package:flutter/material.dart';

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
            Padding(padding: EdgeInsets.only(top: 8)),
            Center(
              child: Text("Online services are currently down for maintenance."),
            )
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
      ),
    );
  }
}
