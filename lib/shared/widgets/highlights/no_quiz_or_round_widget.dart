import 'package:flutter/material.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';

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
      height: 128,
      margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => type == NoQuizOrRoundWidgetType.QUIZ
                  ? QuizEditorPage(
                      type: QuizEditorPageType.ADD,
                    )
                  : RoundEditorPage(
                      type: RoundEditorPageType.ADD,
                    ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CreateNewQuizOrRoundTile(type: type),
            CreateNewRoundOrQuizSummary(type: type),
          ],
        ),
      ),
    );
  }
}

class CreateNewQuizOrRoundTile extends StatelessWidget {
  const CreateNewQuizOrRoundTile({
    Key key,
    @required this.type,
  }) : super(key: key);

  final NoQuizOrRoundWidgetType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Theme.of(context).accentColor),
      ),
      child: Center(
        child: Text(
          type == NoQuizOrRoundWidgetType.QUIZ ? "Create New Quiz" : "Create New Round",
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CreateNewRoundOrQuizSummary extends StatelessWidget {
  const CreateNewRoundOrQuizSummary({
    Key key,
    @required this.type,
  }) : super(key: key);

  final NoQuizOrRoundWidgetType type;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        child: Text(
          type == NoQuizOrRoundWidgetType.QUIZ
              ? "Your library of Quizzes lives here. Tap here to create your first Quiz.\n\nTo save a pre-created Quiz, hit the explore tab and start searching."
              : "Your library of Rounds lives here. Tap here to create your first Round.\n\nTo save a pre-created Round, hit the explore tab and start searching.",
        ),
      ),
    );
  }
}
