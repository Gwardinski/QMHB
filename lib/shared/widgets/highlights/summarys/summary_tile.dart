import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../../get_it.dart';

class SummaryTile extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final String line2Value;
  final String line3Value;
  final String imageURL;
  final Function onTap;

  SummaryTile({
    @required this.line1,
    @required this.line2,
    @required this.line2Value,
    @required this.line3,
    @required this.line3Value,
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
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: SummaryTileTitle(line1: line1)),
                  SummaryTileInfoRow(value: line2Value, title: line2),
                  SummaryTileInfoRow(value: line3Value, title: line3),
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
        maxLines: 3,
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        Text(" $title"),
      ],
    );
  }
}
