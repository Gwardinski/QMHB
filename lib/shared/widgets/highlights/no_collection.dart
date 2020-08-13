import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';

enum NoCollectionType {
  QUIZ,
  ROUND,
}

class NoCollection extends StatelessWidget {
  final NoCollectionType type;

  NoCollection({
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      margin: EdgeInsets.fromLTRB(
        getIt<AppSize>().rSpacingMd,
        getIt<AppSize>().lOnly8,
        getIt<AppSize>().rSpacingMd,
        getIt<AppSize>().rSpacingSm,
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => type == NoCollectionType.QUIZ
                  ? QuizEditorPage(
                      type: QuizEditorPageType.ADD,
                    )
                  : RoundEditorPage(
                      type: RoundEditorPageType.ADD,
                    ),
            ),
          );
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CreateNewQuizOrRoundTile(type: type),
              Expanded(
                child: CreateNewRoundOrQuizSummary(type: type),
              ),
            ],
          ),
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

  final NoCollectionType type;

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
          type == NoCollectionType.QUIZ ? "Create New Quiz" : "Create New Round",
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

  final NoCollectionType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Text(
        type == NoCollectionType.QUIZ
            ? "Your library of Quizzes lives here. Tap to create your first Quiz.\n\nTo save a pre-created Quiz, hit the explore tab and start searching."
            : "Your library of Rounds lives here. Tap to create your first Round.\n\nTo save a pre-created Round, hit the explore tab and start searching.",
      ),
    );
  }
}
