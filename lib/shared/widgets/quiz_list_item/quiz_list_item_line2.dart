import 'package:flutter/material.dart';

class QuizListItemLine2 extends StatelessWidget {
  const QuizListItemLine2({
    Key key,
    @required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Text(
            description != '' ? description : 'no description',
            style: TextStyle(fontStyle: description != '' ? FontStyle.normal : FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
