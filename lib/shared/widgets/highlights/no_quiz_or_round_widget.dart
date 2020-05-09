import 'package:flutter/material.dart';
import 'package:qmhb/screens/quizzes/quiz_add_page.dart';
import 'package:qmhb/screens/rounds/round_add_page.dart';

enum NoQuizOrRoundWidgetType {
  QUIZ,
  ROUND,
}

class NoQuizOrRoundWidget extends StatelessWidget {
  final NoQuizOrRoundWidgetType type;

  NoQuizOrRoundWidget({
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        type == NoQuizOrRoundWidgetType.QUIZ ? QuizAddPage() : RoundAddPage(),
                  ),
                );
              },
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Color(0xffFFA630)),
                ),
                child: Center(
                  child: Text(
                    type == NoQuizOrRoundWidgetType.QUIZ ? "Create New Quiz" : "Create New Round",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: Text(type == NoQuizOrRoundWidgetType.QUIZ
                  ? "Any quizzes you save or create will sit here. To create your own Quiz press the create button. To save a pre-created quiz to your collection, hit the explore tab and start searching."
                  : "Any rounds you save or create will sit here. To create your own Round press the create button. To save a pre-created round to your collection, hit the explore tab and start searching."),
            ),
          ),
        ],
      ),
    );
  }
}
