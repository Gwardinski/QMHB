import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';

import '../../../get_it.dart';

enum GridItemType {
  ROUND,
  QUIZ,
}

class GridItem extends StatefulWidget {
  final GridItemType type;
  final String title;
  final String description;
  final String imageUrl;
  final int number;
  final double points;
  final Widget action;

  GridItem({
    @required this.type,
    @required this.title,
    @required this.description,
    @required this.number,
    @required this.points,
    @required this.imageUrl,
    @required this.action,
  });

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(getIt<AppSize>().borderRadius);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(borderRadius),
          border: Border.all(color: Theme.of(context).accentColor),
          image: DecorationImage(
            fit: BoxFit.cover,
            alignment: Alignment.center,
            matchTextDirection: true,
            repeat: ImageRepeat.noRepeat,
            image: NetworkImage(widget.imageUrl),
          ),
        ),
        child: MouseRegion(
          onEnter: (m) => setState(() => isHover = false),
          onExit: (m) => setState(() => isHover = false),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: isHover == true
                    ? GridItemDescription(
                        borderRadius: borderRadius,
                        description: widget.description,
                      )
                    : GridItemTitle(
                        borderRadius: borderRadius,
                        title: widget.title,
                        number: widget.number,
                        points: widget.points,
                        type: widget.type,
                      ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: widget.action != null ? widget.action : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridItemTitle extends StatelessWidget {
  final String title;
  final int number;
  final double points;
  final GridItemType type;
  final Radius borderRadius;

  GridItemTitle({
    @required this.borderRadius,
    @required this.title,
    @required this.number,
    @required this.points,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: borderRadius,
          bottomRight: borderRadius,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text(
              title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    number.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    type == GridItemType.ROUND ? " Questions" : " Rounds",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    points.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    " Pts",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class GridItemDescription extends StatelessWidget {
  final borderRadius;
  final description;

  GridItemDescription({
    @required this.borderRadius,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.all(borderRadius),
      ),
      padding: EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 48)),
                  Text(description ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridItemNew extends StatelessWidget {
  final String title;
  final String description;
  final Function onTap;

  GridItemNew({
    @required this.title,
    @required this.description,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = Radius.circular(getIt<AppSize>().borderRadius);
    return InkWell(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(borderRadius),
            border: Border.all(color: Theme.of(context).accentColor),
          ),
          child: Center(
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
