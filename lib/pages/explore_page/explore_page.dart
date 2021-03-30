import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Explore'),
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
            //   primaryHeaderButtonText: "Search All Quizzes",
            //   primaryHeaderButtonFunction: () {
            //     Provider.of<GlobalKey<NavigatorState>>(context, listen: false).currentState.push(
            //       MaterialPageRoute(
            //         builder: (context) => QuizzesPage(),
            //       ),
            //     );
            //   },
            // ),
            // RoundRow(
            //   headerTitle: "Featured Rounds",
            //   primaryHeaderButtonText: "Search All Rounds",
            //   primaryHeaderButtonFunction: () {
            //     Provider.of<GlobalKey<NavigatorState>>(context, listen: false).currentState.push(
            //       MaterialPageRoute(
            //         builder: (context) => RoundsPage(),
            //       ),
            //     );
            //   },
            // ),
            // QuestionRow(
            //   headerTitle: "Featured Questions",
            //   primaryHeaderButtonText: "Search All Questions",
            //   primaryHeaderButtonFunction: () {
            //     Provider.of<GlobalKey<NavigatorState>>(context, listen: false).currentState.push(
            //       MaterialPageRoute(
            //         builder: (context) => QuestionsPage(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
