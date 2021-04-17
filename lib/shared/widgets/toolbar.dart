import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_secondary.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    @required this.onUpdateSearchString,
    this.primaryText,
    this.primaryAction,
    this.secondaryText,
    this.secondaryAction,
  }) : super(key: key);

  final Function onUpdateSearchString;
  final String primaryText;
  final Function primaryAction;
  final String secondaryText;
  final Function secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        primaryText != null
            ? ButtonSecondary(
                title: primaryText,
                onTap: primaryAction,
              )
            : Container(),
        Expanded(
          child: Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Search...',
                    ),
                    onChanged: onUpdateSearchString,
                  ),
                ),
              ],
            ),
          ),
        ),
        secondaryText != null
            ? ButtonSecondary(
                title: secondaryText,
                onTap: secondaryAction,
              )
            : Container(),
      ],
    );
  }
}

class SearchDetails extends StatelessWidget {
  final int number;

  const SearchDetails({
    Key key,
    this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: (55)),
      child: Row(
        children: [
          Text("$number results"),
        ],
      ),
    );
  }
}
