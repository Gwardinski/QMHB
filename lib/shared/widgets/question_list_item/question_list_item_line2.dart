import 'package:flutter/material.dart';

class QuestionListItemLine2 extends StatelessWidget {
  const QuestionListItemLine2({
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
