import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_text.dart';

class SummaryRowHeader extends StatelessWidget {
  final String title;
  final String buttonText;
  final Function buttonFunction;

  const SummaryRowHeader({
    Key key,
    @required this.title,
    @required this.buttonText,
    @required this.buttonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title),
          ButtonText(
            text: buttonText,
            onTap: () {
              buttonFunction();
            },
          ),
        ],
      ),
    );
  }
}
