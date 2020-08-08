import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/questions/question_details_page.dart';
import 'package:qmhb/screens/library/questions/round_selector/round_selector_page.dart';

class ListItemQuestion extends StatefulWidget {
  final QuestionModel questionModel;

  ListItemQuestion({
    Key key,
    @required this.questionModel,
  }) : super(key: key);

  @override
  _ListItemQuestionState createState() => _ListItemQuestionState();
}

class _ListItemQuestionState extends State<ListItemQuestion> {
  bool revealAnswer = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionDetailsPage(
              questionModel: widget.questionModel,
            ),
          ),
        );
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RevealAnswerButton(
              revealAnswer: revealAnswer,
              onTap: () {
                setState(() {
                  revealAnswer = !revealAnswer;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 16),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionAndAnswer(
                    text: revealAnswer == true
                        ? widget.questionModel.answer
                        : widget.questionModel.question,
                    highlight: revealAnswer,
                  ),
                  PointsAndCategory(
                    points: widget.questionModel.points.toString(),
                    category: widget.questionModel.category,
                  ),
                ],
              ),
            ),
            AddToRoundButton(
              questionId: widget.questionModel.uid,
              questionPoints: widget.questionModel.points,
            ),
          ],
        ),
      ),
    );
  }
}

class PointsAndCategory extends StatelessWidget {
  const PointsAndCategory({
    Key key,
    @required this.points,
    @required this.category,
  }) : super(key: key);

  final String points;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Row(
            children: <Widget>[
              Text("Points: "),
              Text(
                points,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 32)),
          Text(
            category,
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionAndAnswer extends StatelessWidget {
  const QuestionAndAnswer({
    Key key,
    @required this.text,
    @required this.highlight,
  }) : super(key: key);

  final String text;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          child: Center(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 18,
                color: highlight ? Theme.of(context).accentColor : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AddToRoundButton extends StatelessWidget {
  const AddToRoundButton({
    Key key,
    @required this.questionId,
    @required this.questionPoints,
  }) : super(key: key);

  final questionId;
  final questionPoints;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        child: Container(
          width: 32,
          height: 32,
          child: Center(
            child: Icon(
              Icons.add,
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RoundSelectorPage(
                questionId: questionId,
                questionPoints: questionPoints,
              ),
            ),
          );
        },
      ),
    );
  }
}

class RevealAnswerButton extends StatelessWidget {
  const RevealAnswerButton({
    Key key,
    @required this.revealAnswer,
    @required this.onTap,
  }) : super(key: key);

  final bool revealAnswer;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 32,
        height: 32,
        child: Center(
          child: Icon(
            Icons.remove_red_eye,
            color: revealAnswer ? Theme.of(context).accentColor : Colors.white,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
