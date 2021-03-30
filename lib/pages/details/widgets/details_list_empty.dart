import 'package:flutter/material.dart';

class DetailsListEmpty extends StatelessWidget {
  const DetailsListEmpty({
    Key key,
    @required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(text),
        ],
      ),
    );
  }
}
