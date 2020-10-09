import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/quiz_create_dialog.dart';
import 'package:qmhb/screens/library/rounds/round_create_dialog.dart';

enum CreateNewQuizOrRoundType {
  QUIZ,
  ROUND,
}

class CreateNewQuizOrRound extends StatelessWidget {
  final CreateNewQuizOrRoundType type;

  CreateNewQuizOrRound({
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
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return type == CreateNewQuizOrRoundType.QUIZ
                  ? QuizCreateDialog()
                  : RoundCreateDialog();
            },
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

  final CreateNewQuizOrRoundType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor),
        borderRadius: BorderRadius.all(
          Radius.circular(getIt<AppSize>().borderRadius),
        ),
      ),
      child: Center(
        child: Text(
          type == CreateNewQuizOrRoundType.QUIZ ? "Create New Quiz" : "Create New Round",
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

  final CreateNewQuizOrRoundType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Text(
        type == CreateNewQuizOrRoundType.QUIZ
            ? "Your library of Quizzes lives here.\n\nTap to create your first Quiz, or hit the explore tab and start searching."
            : "Your library of Rounds lives here.\n\nTap to create your first Round, or hit the explore tab and start searching.",
      ),
    );
  }
}
