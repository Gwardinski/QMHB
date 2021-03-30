import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_line1.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_line2.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_line3.dart';

class ListItemDetails extends StatelessWidget {
  const ListItemDetails({
    Key key,
    @required this.title,
    @required this.description,
    @required this.info1Title,
    @required this.info1Value,
    @required this.info2Title,
    @required this.info2Value,
    @required this.info3Title,
    @required this.info3Value,
  }) : super(key: key);

  final String title;
  final String description;
  final String info1Title;
  final String info1Value;
  final String info2Title;
  final String info2Value;
  final String info3Title;
  final String info3Value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListItemLine1(
            title: title,
          ),
          ListItemLine2(
            description: description,
          ),
          ListItemLine3(
            info1Title: info1Title,
            info1Value: info1Value,
            info2Title: info2Title,
            info2Value: info2Value,
            info3Title: info3Title,
            info3Value: info3Value,
          ),
        ],
      ),
    );
  }
}
