import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_text.dart';

class SummaryRowHeader extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;

  const SummaryRowHeader({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(headerTitle),
          ButtonText(
            text: headerButtonText,
            onTap: () {
              headerButtonFunction();
            },
          ),
        ],
      ),
    );
  }
}
