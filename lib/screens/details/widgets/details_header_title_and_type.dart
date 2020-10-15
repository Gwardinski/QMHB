import 'package:flutter/material.dart';

class DetailsHeaderTypeAndTitle extends StatelessWidget {
  const DetailsHeaderTypeAndTitle({
    @required this.type,
    @required this.title,
    @required this.hasImage,
  });

  final String type;
  final String title;
  final bool hasImage;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: hasImage ? 200 : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: hasImage ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Text(type),
            ),
            Container(
              child: Text(
                title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
