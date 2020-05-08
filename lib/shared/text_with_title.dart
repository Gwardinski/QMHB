import 'package:flutter/material.dart';

class TextListItem extends StatelessWidget {
  const TextListItem({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            '$title:',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: highlighText ? Color(0xffFFA630) : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
