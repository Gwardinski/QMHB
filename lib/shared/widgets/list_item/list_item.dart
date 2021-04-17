import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String infoTitle1;
  final String infoTitle2;
  final int number;
  final double points;
  final Widget action;

  ListItem({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.infoTitle1,
    @required this.infoTitle2,
    @required this.number,
    @required this.points,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: Stack(
        children: [
          ItemBackgroundImage(imageUrl: imageUrl),
          ListItemDetails(
            title: title,
            description: description,
            info1Title: infoTitle1,
            info1Value: number.toString(),
            info2Title: infoTitle2,
            info2Value: points.toString(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: action != null
                ? action
                : Container(
                    width: 64,
                  ),
          ),
        ],
      ),
    );
  }
}
