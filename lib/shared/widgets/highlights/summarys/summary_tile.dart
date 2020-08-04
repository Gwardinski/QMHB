import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final String line4;
  final int line2Value;
  final double line3Value;
  final double line4Value;
  final Function onTap;

  const SummaryTile({
    Key key,
    @required this.line1,
    @required this.line2,
    @required this.line2Value,
    @required this.line3,
    @required this.line3Value,
    this.line4 = "line4",
    this.line4Value = 0,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 128,
        width: 128,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          border: Border.all(color: Theme.of(context).accentColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SummaryTileTitle(line1: line1),
            SummaryTileInfoRow(value: line2Value.toString(), title: line2),
            SummaryTileInfoRow(value: line3Value.toString(), title: line3),
            SummaryTileInfoRow(value: line4Value.toString(), title: line4),
          ],
        ),
      ),
    );
  }
}

class SummaryTileTitle extends StatelessWidget {
  const SummaryTileTitle({
    Key key,
    @required this.line1,
  }) : super(key: key);

  final String line1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: Text(
          line1,
          maxLines: 2,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SummaryTileInfoRow extends StatelessWidget {
  const SummaryTileInfoRow({
    Key key,
    @required this.title,
    @required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        Text(title),
      ],
    );
  }
}
