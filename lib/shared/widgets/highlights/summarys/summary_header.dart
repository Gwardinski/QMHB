import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_text.dart';

class SummaryRowHeader extends StatelessWidget {
  final String headerTitle;
  final Function headerTitleButtonFunction;
  final String primaryHeaderButtonText;
  final Function primaryHeaderButtonFunction;
  final String secondaryHeaderButtonText;
  final Function secondaryHeaderButtonFunction;

  const SummaryRowHeader({
    Key key,
    @required this.headerTitle,
    this.headerTitleButtonFunction,
    this.primaryHeaderButtonText,
    this.primaryHeaderButtonFunction,
    this.secondaryHeaderButtonText,
    this.secondaryHeaderButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ButtonText(
            text: headerTitle,
            onTap: headerTitleButtonFunction,
            type: ButtonTextType.PRIMARY,
          ),
          primaryHeaderButtonText != null
              ? Row(
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
                )
              : Container(),
        ],
      ),
    );
  }
}
