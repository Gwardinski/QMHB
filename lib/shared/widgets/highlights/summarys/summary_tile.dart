import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final int line2Value;
  final double line3Value;
  final Function onTap;

  const SummaryTile({
    Key key,
    @required this.line1,
    @required this.line2,
    @required this.line3,
    @required this.line2Value,
    @required this.line3Value,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        line1,
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    line2Value.toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(line2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    line3Value.toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Text(line3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
