import 'package:flutter/material.dart';

class QuestionListItemAction2 extends StatelessWidget {
  const QuestionListItemAction2({
    Key key,
    @required this.revealAnswer,
    @required this.onTap,
  }) : super(key: key);

  final bool revealAnswer;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 32,
        height: 32,
        child: Center(
          child: Icon(
            Icons.remove_red_eye,
            color: revealAnswer ? Theme.of(context).accentColor : Colors.white,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
