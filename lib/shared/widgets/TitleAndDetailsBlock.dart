import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/text_with_title.dart';

class TitleAndDetailsBlock extends StatelessWidget {
  const TitleAndDetailsBlock({
    Key key,
    @required this.title,
    @required this.description,
    this.item1Title,
    this.item1Text,
    this.item2Title,
    this.item2Text,
  }) : super(key: key);

  final String title;
  final String description;
  final String item1Title;
  final String item1Text;
  final String item2Title;
  final String item2Text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 8)),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Padding(padding: EdgeInsets.only(bottom: 4)),
          (item1Title != null && item1Text != null)
              ? TextListItem(title: item1Title, text: item1Text)
              : Container(),
          (item2Title != null && item2Text != null)
              ? TextListItem(title: item2Title, text: item2Text)
              : Container(),
        ],
      ),
    );
  }
}
