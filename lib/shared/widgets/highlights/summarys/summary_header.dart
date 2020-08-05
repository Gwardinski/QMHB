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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ButtonText(
            text: headerTitle,
            onTap: primaryHeaderButtonFunction,
            type: ButtonTextType.PRIMARY,
          ),
          Row(
            children: [
              ButtonText(
                text: primaryHeaderButtonText,
                onTap: primaryHeaderButtonFunction,
                type: ButtonTextType.SECONDARY,
              ),
              (secondaryHeaderButtonText != null && secondaryHeaderButtonFunction != null)
                  ? ButtonText(
                      text: secondaryHeaderButtonText,
                      onTap: secondaryHeaderButtonFunction,
                      type: ButtonTextType.SECONDARY,
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
