import 'package:flutter/material.dart';

class DragFeedback extends StatelessWidget {
  const DragFeedback({
    Key key,
    @required this.title,
  }) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(8),
        height: 46,
        width: 320,
        color: Theme.of(context).accentColor,
        child: Center(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
