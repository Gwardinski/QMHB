import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/button_text.dart';

import '../../../../get_it.dart';

class SummaryRowHeader extends StatelessWidget {
  final String headerTitle;
  final String headerDescription;
  final Function headerTitleButtonFunction;
  final String primaryHeaderButtonText;
  final Function primaryHeaderButtonFunction;

  const SummaryRowHeader({
    Key key,
    @required this.headerTitle,
    this.headerDescription,
    this.headerTitleButtonFunction,
    this.primaryHeaderButtonText,
    this.primaryHeaderButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SummaryTitle(
            title: headerTitle,
            description: headerDescription,
            onTap: headerTitleButtonFunction,
          ),
          primaryHeaderButtonText != null
              ? ButtonText(
                  text: primaryHeaderButtonText,
                  onTap: primaryHeaderButtonFunction,
                  type: ButtonTextType.SECONDARY,
                )
              : Container(),
        ],
      ),
    );
  }
}

class SummaryTitle extends StatelessWidget {
  final String title;
  final String description;
  final Function onTap;

  const SummaryTitle({
    Key key,
    @required this.title,
    @required this.onTap,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            description != null
                ? Container(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
