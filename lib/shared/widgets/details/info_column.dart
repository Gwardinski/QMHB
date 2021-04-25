import 'package:flutter/material.dart';

class InfoColumn extends StatelessWidget {
  const InfoColumn({
    Key key,
    @required this.title,
    @required this.value,
    this.padding = false,
  }) : super(key: key);

  final String title;
  final String value;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: padding ? 32 : 0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).accentColor,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}
