import 'package:flutter/material.dart';

class RoundListItemLine3 extends StatelessWidget {
  const RoundListItemLine3({
    Key key,
    @required this.points,
    @required this.questions,
  }) : super(key: key);

  final String points;
  final String questions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Row(
            children: <Widget>[
              Text(
                questions,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              Text(" Questions"),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 32)),
          Row(
            children: <Widget>[
              Text(
                points,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              Text(" Total Points"),
            ],
          ),
        ],
      ),
    );
  }
}
