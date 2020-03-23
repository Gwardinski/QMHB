import 'package:flutter/material.dart';

class TextWithTitle extends StatelessWidget {
  const TextWithTitle({
    Key key,
    @required this.title,
    @required this.text,
    this.highlighText = false,
  }) : super(key: key);

  final String title;
  final String text;
  final bool highlighText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: highlighText ? Color(0xffFFA630) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
