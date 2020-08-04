import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_text.dart';

class SummaryRowHeader extends StatelessWidget {
  final String headerTitle;
  final String primaryHeaderButtonText;
  final Function primaryHeaderButtonFunction;
  final String secondaryHeaderButtonText;
  final Function secondaryHeaderButtonFunction;

  const SummaryRowHeader({
    Key key,
    @required this.headerTitle,
    @required this.primaryHeaderButtonText,
    @required this.primaryHeaderButtonFunction,
    this.secondaryHeaderButtonText,
    this.secondaryHeaderButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              headerTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              ButtonText(
                text: primaryHeaderButtonText,
                onTap: primaryHeaderButtonFunction,
              ),
              (secondaryHeaderButtonText != null && secondaryHeaderButtonFunction != null)
                  ? ButtonText(
                      text: secondaryHeaderButtonText,
                      onTap: secondaryHeaderButtonFunction,
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
