import 'package:flutter/material.dart';

class ListItemLine3 extends StatelessWidget {
  const ListItemLine3({
    Key key,
    @required this.info1Title,
    @required this.info1Value,
    @required this.info2Title,
    @required this.info2Value,
    @required this.info3Title,
    @required this.info3Value,
  }) : super(key: key);

  final String info1Title;
  final String info1Value;
  final String info2Title;
  final String info2Value;
  final String info3Title;
  final String info3Value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        children: [
          Row(
            children: <Widget>[
              Text(info1Title),
              Text(
                info1Value,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 16)),
          Row(
            children: <Widget>[
              Text(info2Title),
              Text(
                info2Value,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 16)),
          Row(
            children: <Widget>[
              Text(info3Title ?? ""),
              Text(
                info3Value ?? "",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
