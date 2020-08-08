import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/rounds/quiz_selector/quiz_selector_page.dart';
import 'package:qmhb/screens/library/rounds/round_details_page.dart';

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
      child: ListItemInfo(
        title: quizModel.title,
        infoTitle1: "Rounds",
        infoValue1: quizModel.roundIds.length.toString(),
        infoTitle2: "Questions",
        infoValue2: quizModel.roundIds.length.toString(),
        infoTitle3: "Points",
        infoValue3: quizModel.totalPoints.toString(),
        description: quizModel.description,
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
      child: ListItemInfo(
          title: roundModel.title,
          infoTitle1: "Questions",
          infoValue1: roundModel.questionIds.length.toString(),
          infoTitle2: "Questions",
          infoValue2: roundModel.questionIds.length.toString(),
          infoTitle3: "Points",
          infoValue3: roundModel.totalPoints.toString(),
          description: roundModel.description,
          onAddTo: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => QuizSelectorPage(
                  roundId: roundModel.uid,
                  roundPoints: roundModel.totalPoints,
                ),
              ),
            );
          }),
    );
  }
}

class ListItemInfo extends StatelessWidget {
  const ListItemInfo({
    this.title,
    this.infoTitle1,
    this.infoValue1,
    this.infoTitle2,
    this.infoValue2,
    this.infoTitle3,
    this.infoValue3,
    this.description,
    this.onAddTo,
  });

  final String title;
  final String infoTitle1;
  final String infoValue1;
  final String infoTitle2;
  final String infoValue2;
  final String infoTitle3;
  final String infoValue3;
  final String description;
  final onAddTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: Theme.of(context).bottomAppBarColor,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
              onAddTo != null
                  ? MaterialButton(
                      child: Icon(
                        Icons.add,
                      ),
                      onPressed: () {
                        onAddTo();
                      },
                    )
                  : Container()
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ListItemInfoBadge(value: infoValue1, title: infoTitle1),
                ListItemInfoBadge(value: infoValue2, title: infoTitle2),
                ListItemInfoBadge(value: infoValue3, title: infoTitle3),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListItemInfoBadge extends StatelessWidget {
  const ListItemInfoBadge({
    Key key,
    @required this.value,
    @required this.title,
  }) : super(key: key);

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 8)),
          Text(title),
        ],
      ),
    );
  }
}
