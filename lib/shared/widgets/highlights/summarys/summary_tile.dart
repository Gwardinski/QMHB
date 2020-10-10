import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../../get_it.dart';

class SummaryTile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final String line4;
  final int line2Value;
  final double line3Value;
  final double line4Value;
  final String imageURL;
  final Function onTap;

  SummaryTile({
    @required this.line1,
    @required this.line2,
    @required this.line2Value,
    @required this.line3,
    @required this.line3Value,
    this.line4,
    this.line4Value,
    this.imageURL,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 128,
        width: 128,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(getIt<AppSize>().borderRadius)),
          border: Border.all(color: Theme.of(context).accentColor),
          image: imageURL != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  matchTextDirection: true,
                  repeat: ImageRepeat.noRepeat,
                  image: NetworkImage(imageURL),
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(getIt<AppSize>().borderRadius)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: SummaryTileTitle(line1: line1)),
                  SummaryTileInfoRow(value: line2Value.toString(), title: line2),
                  SummaryTileInfoRow(value: line3Value.toString(), title: line3),
                  line4Value != null
                      ? SummaryTileInfoRow(value: line4Value.toString(), title: line4)
                      : Container(),
                ],
              ),
            ),
          ),
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
    return Container(
      width: double.infinity,
      child: Text(
        line1,
        maxLines: 2,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 18),
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
