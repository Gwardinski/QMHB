import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/button_secondary.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    @required this.onUpdateSearchString,
    this.initialValue,
    this.primaryText,
    this.leftIcon,
    this.primaryAction,
    this.secondaryText,
    this.secondaryAction,
  }) : super(key: key);

  final Function onUpdateSearchString;
  final String initialValue;
  final String primaryText;
  final IconData leftIcon;
  final Function primaryAction;
  final String secondaryText;
  final Function secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppBarButton(
          title: primaryText,
          onTap: primaryAction,
          leftIcon: leftIcon,
        ),
        Expanded(
          child: Container(
            height: 64,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: initialValue,
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("$number results"),
        ],
      ),
    );
  }
}
