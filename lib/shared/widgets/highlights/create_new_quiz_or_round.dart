import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/quiz_add_modal.dart';
import 'package:qmhb/screens/library/rounds/round_add_modal.dart';

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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  type == CreateNewQuizOrRoundType.QUIZ ? QuizAddModal() : RoundAddModal(),
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

  final CreateNewQuizOrRoundType type;

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
            ? "Your library of Quizzes lives here. Tap to create your first Quiz.\n\nTo save a pre-created Quiz, hit the explore tab and start searching."
            : "Your library of Rounds lives here. Tap to create your first Round.\n\nTo save a pre-created Round, hit the explore tab and start searching.",
      ),
    );
  }
}
