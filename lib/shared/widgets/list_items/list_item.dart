import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_tile.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    this.quizModel,
    this.roundModel,
  });

  final QuizModel quizModel;
  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return quizModel != null
        ? QuizListItem(
            quizModel: quizModel,
          )
        : RoundListItem(
            roundModel: roundModel,
          );
  }
}

class QuizListItem extends StatelessWidget {
  const QuizListItem({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizDetailsPage(
              quizModel: quizModel,
            ),
          ),
        );
      },
      child: Container(
        height: 160,
        color: Theme.of(context).bottomAppBarColor,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            IgnorePointer(
              child: SummaryTile(
                line1: "",
                line2: "Rounds",
                line2Value: quizModel.roundIds.length,
                line3: "Points",
                line3Value: quizModel.totalPoints,
                onTap: () {},
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: double.infinity,
                      child: Text(
                        quizModel.title,
                        maxLines: 2,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: double.infinity,
                      child: Text(
                        quizModel.description,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundListItem extends StatelessWidget {
  const RoundListItem({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoundDetailsPage(
              roundModel: roundModel,
            ),
          ),
        );
      },
      child: Container(
        height: 160,
        color: Theme.of(context).bottomAppBarColor,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            IgnorePointer(
              child: SummaryTile(
                line1: "",
                line2: "Questions",
                line2Value: roundModel.questionIds.length,
                line3: "Points",
                line3Value: roundModel.totalPoints,
                onTap: () {},
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                      width: double.infinity,
                      child: Text(
                        roundModel.title,
                        maxLines: 2,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      width: double.infinity,
                      child: Text(
                        roundModel.description,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
