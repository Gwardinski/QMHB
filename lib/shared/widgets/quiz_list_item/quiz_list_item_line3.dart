import 'package:flutter/material.dart';

class QuizListItemLine3 extends StatelessWidget {
  const QuizListItemLine3({
    Key key,
    @required this.points,
    @required this.rounds,
    @required this.questions,
  }) : super(key: key);

  final String points;
  final String rounds;
  final String questions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Row(
            children: <Widget>[
              Text("Rounds: "),
              Text(
                rounds,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 32)),
          Row(
            children: <Widget>[
              Text("Questions: "),
              Text(
                questions,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 32)),
          Row(
            children: <Widget>[
              Text("Total Points: "),
              Text(
                points,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
