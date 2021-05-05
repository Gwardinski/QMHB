import 'package:flutter/material.dart';

class EditorHeader extends StatelessWidget {
  final String title;

  EditorHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}
