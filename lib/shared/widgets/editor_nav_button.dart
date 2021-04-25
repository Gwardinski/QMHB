import 'package:flutter/material.dart';

class EditorNavButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool highlight;
  final bool disable;
  final double width;
  final double height;

  const EditorNavButton({
    @required this.title,
    @required this.onTap,
    @required this.highlight,
    @required this.disable,
    this.width = 140,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disable ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: highlight ? Theme.of(context).accentColor.withOpacity(0.2) : Colors.transparent,
          border: highlight
              ? Border(
                  bottom: BorderSide(
                    width: 4.0,
                    color: Theme.of(context).accentColor,
                  ),
                )
              : null,
        ),
        width: width,
        height: 64,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: disable
                  ? Theme.of(context).backgroundColor
                  : highlight
                      ? Theme.of(context).accentColor
                      : Theme.of(context).selectedRowColor,
            ),
          ),
        ),
      ),
    );
  }
}
