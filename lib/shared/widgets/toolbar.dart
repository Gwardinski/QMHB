import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/button_secondary.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    Key key,
    @required this.onUpdateSearchString,
    @required this.noOfResults,
    this.primaryText,
    this.primaryAction,
  }) : super(key: key);

  final Function onUpdateSearchString;
  final int noOfResults;
  final String primaryText;
  final Function primaryAction;

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
          child: Column(
            children: [
              Container(
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
              Container(
                height: 32,
                padding: EdgeInsets.symmetric(horizontal: (55)),
                child: Row(
                  children: [
                    Text("$noOfResults results"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
