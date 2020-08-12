import 'package:flutter/material.dart';

class QuestionListItemLine1 extends StatelessWidget {
  const QuestionListItemLine1({
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
