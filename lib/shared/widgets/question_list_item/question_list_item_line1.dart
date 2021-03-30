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
    return Container(
      height: 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: 18,
              color: highlight ? Theme.of(context).accentColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
